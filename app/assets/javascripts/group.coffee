# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

load_absenses = (data) ->
  $.get '/group/get_updated_view_absenses',
    data,
    (data) ->
      build_visits data
      return
  return

build_visits = (data) ->
  table = $('.group__absenses__table')
  header_row = table.find('.group__absenses__table__header__row')
  build_header header_row, data.response.semester

  body = table.find('.group__absenses__table__body')
  build_body body, data.response
  return

build_header = (row, semester) ->
  row.empty()
  row.append('<th class="group__absenses__table__header__row__item">№</th>\
        <th class="group__absenses__table__header__row__item">Студент</th>')

  for week, week_index in semester
    for week_lesson in week
      th = $('<th class="group__absenses__table__header__row__item"></th>')
      row.append th
      th.html(
        "W#{week_index + 1}<br/>\
         D#{week_lesson.weekday + 1}<br/>\
         T#{week_lesson.time_index + 1}"
      )
  return

build_body = (body, response) ->
  body.empty()
  for student, student_index in response.students
    tr = $('<tr class="group__absenses__table__body__row"></tr>')
    body.append tr
    tr.append("<td class=\"group__absenses__table__body__row__item\">#{student_index}</td>")
    tr.append("<td class=\"group__absenses__table__body__row__item\">#{student.name}</td>")

    for week, week_index in response.semester
      for week_lesson in week
        td = $('<td class="group__absenses__table__body__row__item group__absenses__table__body__row__item_visit"></td>')
        tr.append(td)
        content = ''
        if student.name of response.absenses
          obj = "{:week=>#{week_index}, :weekday=>#{week_lesson.weekday}, :time=>#{week_lesson.time_index}}"
          if obj of response.absenses[student.name]
            content = 'Н'
            td.addClass('group__absenses__table__body__row__item_missing')
        td.text content
        td.data('week', week_index)
        td.data('weekday', week_lesson.weekday)
        td.data('time_index', week_lesson.time_index)
        td.data('user_id', student.id)
        td.data('lesson_id', week_lesson.lesson_id)

  hang_methods()
  return

hang_methods = ->
  $('.group__absenses__table__body__row__item_visit')
  .click (eventObject) ->
    td = $(eventObject.target)
    switch_absense(td)
    return

switch_absense = (td) ->
  if td.hasClass('group__absenses__table__body__row__item_missing')
    $.post '/group/delete_absense',
      { absense: td.data() },
      (response) ->
        if response.code == 200
          td.removeClass('group__absenses__table__body__row__item_missing')
          td.text ''
  else
    $.post '/group/create_absense',
      { absense: td.data() },
      (response) ->
        if response.code == 200
          td.addClass('group__absenses__table__body__row__item_missing')
          td.text 'Н'
  return

$(document).ready ->
  selection_form = $('.group__absenses__discipline__selector')
  load_absenses selection_form.serialize()
  $('.group__absenses__discipline__selector select[name="absenses_table[discipline_id]"], select[name="absenses_table[lesson_type]"]')
  .change (eventObject) ->
    selection_form = $('.group__absenses__discipline__selector')
    load_absenses selection_form.serialize()
    return
  return

