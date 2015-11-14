# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$.ajaxSetup({
  dataType: 'json'
})


ready = ->
  form = $(".user__profile form").first().on("ajax:send", (event, xhr, options) ->
    $(event.target).find(".entity__form__input-group__err")
      .empty()
      .hide()
  ).on("ajax:success", (e, data, status, xhr) ->
    model_params = ['name', 'email', 'date_of_birth']
    for param in model_params
      $(e.target).find('#user_'+param).val(data[param])
    $('.app__wrapper__topwrapper__topbar__userbar__name').text(data['short_name'])
  ).on("ajax:error", (e, response, settings, thrownError) ->
    data = $.parseJSON(response.responseText)
    if 'message' of data
      alert(data['message'])
    else
      console.log(data)
      for param,msg_arr of data
        param_call = param.capitalizeFirstLetter()
        helper = $(e.target).find('#user_'+param+'_err')
        console.log(helper)
        for msg in msg_arr
          helper.append document.createTextNode("#{param_call} #{msg}")
          helper.append "<br/>"
        helper.show()
  )

$(document).ready(ready)
$(document).on('page:load', ready)
