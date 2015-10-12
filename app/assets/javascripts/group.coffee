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
    tr.append("<td class=\"group__absenses__table__body__row__item\">#{student}</td>")

    for week, week_index in response.semester
      for week_lesson in week
        td = $('<td class="group__absenses__table__body__row__item"></td>')
        tr.append(td)
        content = ''
        if student of response.absenses
          obj = "{:week=>#{week_index}, :weekday=>#{week_lesson.weekday}, :time=>#{week_lesson.time_index}}"
          if obj of response.absenses[student]
            content = 'Н'
        td.text content
  return

$(document).ready ->
  $('.group__absenses__discipline__selector select[name="absenses_table[discipline_id]"], select[name="absenses_table[lesson_type]"]')
  .change (eventObject) ->
    #debugger;
    selection_form = $('.group__absenses__discipline__selector')
    load_absenses selection_form.serialize()
    return
  return

