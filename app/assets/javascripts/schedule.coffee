# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

get_schedule_form = (inflatee, time_index, weekday_index, occurence_type = 0) ->
  form = $('<form method="post" accept-charset="UTF-8" action="/schedule/update_item" autocomplete="off"></form>')
  inflatee.append(form)

  csrf = $('meta[name=csrf-token]').attr('content')
  utf_tag = $('<input type="hidden" value="✓" name="utf8"/>')
  csrf_tag = $('<input type="hidden" name="authenticity_token">').val(csrf)

  $.ajax
    url: '/discipline/listDisciplines.json',
    success: (data) ->
      discipline_select = $('<select name="lesson[discipline_id]"></select>')
      discipline_select.append '<option value="" selected="selected">None</option>'
      for discipline in data.disciplines
        option = $('<option></option>')
        option.val discipline.id
        option.text discipline.name
        discipline_select.append option

      lesson_type_select = $('<select name="lesson[lesson_type]">\
      <option value="0" selected="selected">Лекция</option>\
      <option value="1">Семинар</option>\
      <option value="2">Лабораторная работа</option>\
      </select>')
      weekday_tag = $('<input type="hidden" id="" name="lesson[weekday]"/>').val(weekday_index)
      time_tag = $('<input type="hidden" name="lesson[time_index]">').val(time_index)
      occurence_tag = $('<input type="hidden" name="lesson[occurence_type]"/>').val(occurence_type)
      submit_tag = $('<input type="submit" value="Update item" name="commit">')

      form.append(utf_tag).append(csrf_tag).append(discipline_select)
      .append(lesson_type_select).append(weekday_tag).append(time_tag)
      .append(occurence_tag).append(submit_tag)
      return

get_tr2 = (time_index, weekday_index) ->
  tr2 = $('<tr class="schedule__timetable__timerow"></tr>')
    .data('pair-time', time_index)
    .data('pair-wday', weekday_index)
  tr2.append('<td class="schedule__timetable__timerow__pair"></td>')
  get_schedule_form tr2.find('td'), time_index, weekday_index, 2
  tr2

ready = ->
  $('.schedule__timetable__timerow__time__split').click (eventObject) ->
    button_texts = ['Split', 'Join']
    button = $(eventObject.target)
    time_cell = button.closest '.schedule__timetable__timerow__time'
    tr1 = time_cell.closest '.schedule__timetable__timerow'
    time_index = tr1.data 'pair-time'
    wday = tr1.data 'pair-wday'
    rowspan = parseInt time_cell.attr('rowspan')
    switch rowspan
      when 1
        tr1.after(get_tr2 time_index, wday)
      when 2
        tr2 = tr1.next()
        tr2.remove()
    time_cell.attr('rowspan', 3 - rowspan)
    tr1.find('input[name="lesson[occurence_type]"]').val(2 - rowspan)
    button.text button_texts[2 - rowspan]

$(document).ready(ready)
$(document).on('page:load', ready)
