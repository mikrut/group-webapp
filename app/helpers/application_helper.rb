module ApplicationHelper
  def input_or_read(model, method, can_edit, mytag, myinput, content, options = {})
    if can_edit
      options[:value] = content
      send myinput, model, method, options
    else
      content_tag mytag, content, options
    end
  end

  def form_tag_or_nothing(can_edit = false, url_for_options = {}, options = {}, &block)
    if can_edit
      form_tag url_for_options, options, &block
    else
      block
    end
  end
end
