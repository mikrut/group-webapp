# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

received_data = null

load_absenses = (data) ->
  $.get '/group/get_updated_view_absenses',
    data,
    (data) ->
      received_data = data
      build_visits()
      return
  return

build_visits = () ->
  table = $('.group__absenses__table')
  if received_data.code == 200
    header_row = table.find('.group__absenses__table__header__row')
    build_header header_row, received_data.response.semester

    body = table.find('.group__absenses__table__body')
    build_body body, received_data.response
  else
    table.empty()
    table.append('<thead class="group__absenses__table__header">
      <tr class="group__absenses__table__header__row">
        <th class="group__absenses__table__header__row__item">Расписание недоступно</th>
      </tr>
    </thead>
    <tbody class="group__absenses__table__body">
      <tr class="group__absenses__table__body__row">
        <td class="group__absenses__table__body__row__item">Ошибка получения данных</td>
      </tr>
    </tbody>')
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

  row.append('<th class="group__absenses__table__header__row__item">% Успеваемости</th>')
  return

$.fn.filterByData = (prop, val) ->
    this.filter(
        () -> $(this).data(prop)==val
    )

build_body = (body, response) ->
  body.empty()
  for student, student_index in response.students
    tr = $('<tr class="group__absenses__table__body__row"></tr>')
    body.append tr
    tr.append("<td class=\"group__absenses__table__body__row__item\">#{student_index + 1}</td>")
    tr.append("<td class=\"group__absenses__table__body__row__item\">#{student.name}</td>")
    tr.data('user_id', student.id)

    for week, week_index in response.semester
      for week_lesson in week
        td = $('<td class="group__absenses__table__body__row__item group__absenses__table__body__row__item_visit"></td>')
        tr.append(td)
        td.data('week', week_index)
        td.data('weekday', week_lesson.weekday)
        td.data('time_index', week_lesson.time_index)
        td.data('user_id', student.id)
        td.data('lesson_id', week_lesson.lesson_id)

    td = $("<td class=\"group__absenses__table__body__row__item group__absenses__table__body__row__item_perc\">\
    \<input type=\"text\" />
    </td>")
    td.data('user_id', student.id)
    td.data('discipline_id', received_data.response.discipline_id)
    tr.append(td)

  for absense in response.absenses
    student_row = body.find(".group__absenses__table__body__row").filterByData('user_id', absense.user_id);
    td = student_row.find("td").filterByData('week', absense.week)
      .filterByData('weekday', absense.weekday)
      .filterByData('time_index', absense.time_index)
    td.text('Н')
    td.addClass('group__absenses__table__body__row__item_missing')

  for progress in response.progresses
    student_row = body.find(".group__absenses__table__body__row").filterByData('user_id', progress.user_id);
    input = student_row.find(".group__absenses__table__body__row__item_perc input")
    input.val(progress.percentage)
  hang_methods()
  return

hang_methods = ->
  $('.group__absenses__table__body__row__item_visit')
  .click (eventObject) ->
    td = $(eventObject.target)
    switch_absense(td)
    return

  percent_inputs = $('.group__absenses__table__body__row__item_perc input')
  percent_inputs.change (eventObject) ->
    inp = $(eventObject.target)
    record_perc(inp)
    return


switch_absense = (td) ->
  if td.hasClass('group__absenses__table__body__row__item_missing')
    $.post '/group/delete_absense',
      { absense: td.data() },
      (response) ->
        if response.code == 200
          td.removeClass('group__absenses__table__body__row__item_missing')
          td.text ''
        return
  else
    $.post '/group/create_absense',
      { absense: td.data() },
      (response) ->
        if response.code == 200
          td.addClass('group__absenses__table__body__row__item_missing')
          td.text 'Н'
        return
  return

record_perc = (input) ->
  post_data = input.closest('td').data()
  post_data['percentage'] = input.val()
  $.post '/group/update_percentage',
    {progress: post_data},
    (response) ->
      if response.code == 200
      else
      return
  return

ready = ->
  selection_form = $('.group__absenses__discipline__selector')
  if selection_form.length
    console.log('hello')
    load_absenses selection_form.serialize()
  $('.group__absenses__discipline__selector select[name="absenses_table[discipline_id]"], select[name="absenses_table[lesson_type]"]')
  .change (eventObject) ->
    selection_form = $('.group__absenses__discipline__selector')
    load_absenses selection_form.serialize()
    return
  return

$(document).ready(ready)
$(document).on('page:load', ready)

