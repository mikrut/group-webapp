module ApplicationHelper

  def input_or_read(model, method, can_edit, mytag, myinput, content, options = {})
    if can_edit
      options[:value] = content
      html1 = send myinput, model, method, options
      html2 = content_tag 'a', 'OK', class: "ok_#{model.id2name} ok_#{method.id2name}"
      html1 + html2
    else
      content_tag mytag, content, options
    end
  end

  def form_tag_or_nothing(can_edit = false, url_for_options={}, options = {}, &block)
    if can_edit
      form_tag url_for_options, options, &block
    else
      block
    end
  end

end
