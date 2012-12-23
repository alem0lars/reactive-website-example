module ApplicationHelper
  def span_n_for(length, kind)
    case kind.to_sym
    when :floor
      12 / length
    when :ceil
      12 - 12 * (length - 1) / length
    end
  end

  def ajax?
    request.xhr? == 0
  end

  def opt_elem(condition, elem, default_value = 'Not Available.')
    default_elem = content_tag :span, default_value, :class => 'label label-info'
    condition ? elem : default_elem # return
  end
end
