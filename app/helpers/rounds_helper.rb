module RoundsHelper
  def formatLine(label,field)
    formatLabel(label) + formatField(field)
  end

  def formatLabel(label)
    content_tag(:div,content_tag(:label,label.to_s.titlecase)+': ',class:'w-36 text-right font-bold inline-block')
  end

  def formatField(field)
    content_tag(:span,content_tag(:field,field.to_s,class:'inline-block ml-2 border border-green-400 mb-1 px-1'))
  end

end
