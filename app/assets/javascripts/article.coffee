# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$.ajaxSetup({
  dataType: 'json'
})

$(document).ready ->
  form = $("#article_form").first().on("ajax:send", (event, xhr, options) ->
    $(event.target).find(".entity__form__input-group__err")
      .empty()
      .hide()
  ).on("ajax:success", (e, data, status, xhr) ->
    if 'redirect' of data
      window.location = data['redirect']
  ).on("ajax:error", (e, response, status, xhr) ->
    data = $.parseJSON(response.responseText)
    for param,msg_arr of data
      param_call = param.capitalizeFirstLetter()
      helper = $(e.target).find('#article_'+param+'_err')
      for msg in msg_arr
        helper.append document.createTextNode("#{param_call} #{msg}")
        helper.append "<br/>"
      helper.show()
  )
