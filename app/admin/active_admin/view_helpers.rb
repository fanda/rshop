module ActiveAdmin::ViewHelpers
 def state_in(obj)
    labels = ['notice', 'important', 'success', 'warning', 'important']
    content_tag(
      'span', obj.state_in_words,
      :class => "label #{labels[obj.state]}"
    )
  end

  def date_in(obj)
    content_tag(
      'span', obj.created_at.strftime('%e.%-m.%Y'),
      :title => obj.created_at.strftime('%k:%m hodin')
    )
  end
end
