module ShowHelper
  def widget
    content_tag(:div, class: "px-4 mt-4 bg-blue-200 border-l-8 border-blue-500 relative") do
      concat link_to("Hello", hello_path)
      concat " "
      concat link_to("Bye", goodbye_path)
    end
  end

  def callout_warning(content,due_date)
    tag.div class:'px-4 mt-4 bg-yellow-100 border-l-8 border-yellow-500 relative' do 
      concat(tag.button('&cross;'.html_safe,
        class:"absolute -top-3 -right-3 bg-yellow-500 hover:bg-yellow-600 text-2xl w-10 h-10 rounded-full focus:outline-none text-white",
          onclick:"this.parentElement.style.display='none'")) 
      concat(tag.div("Warning Notice -  Expires:#{due_date}",class:'font-bold '))
      concat(content)
    end
  end

  def callout_alert(content,due_date=nil)
    tag.div class:'px-4 mt-4 bg-red-200 border-l-8 border-red-500 relative' do  
      concat(tag.button('&cross;'.html_safe,
        class:"absolute -top-3 -right-3 bg-red-500 hover:bg-red-600 text-2xl w-10 h-10 rounded-full focus:outline-none text-white",
          onclick:"this.parentElement.style.display='none'")) 
      concat(tag.div("Alert Notice -  Expires:#{due_date}",class:'font-bold '))
      concat(content)
    end
  end

  def callout_info(content,due_date=nil)
    due_date = Date.today + 5.days if due_date.blank?
    content_tag(:div, class: "px-4 mt-4 bg-blue-200 border-l-8 border-blue-500 relative") do
      concat(tag.button('&cross;'.html_safe,
        class:"absolute -top-3 -right-3 bg-blue-500 hover:bg-blue-600 text-2xl w-10 h-10 rounded-full focus:outline-none text-white",
          onclick:"this.parentElement.style.display='none'")) 
      concat(tag.div("Information Notice -  Expires:#{due_date}",class:'font-bold '))
      concat(content)
    end
  end

  def callout_success(content,due_date)
    content_tag(:div, class:'px-4 mt-4 bg-green-100 border-l-8  border-green-500 relative') do  
      concat(tag.button('&cross;'.html_safe,
        class:"absolute -top-3 -right-3 bg-green-500 hover:bg-green-600 text-2xl w-10 h-10 rounded-full focus:outline-none text-white",
          onclick:"this.parentElement.style.display='none'")) 
      concat(tag.div("Success Notice -  Expires:#{due_date}",class:'font-bold '))
      concat(content)
    end
  end
end
