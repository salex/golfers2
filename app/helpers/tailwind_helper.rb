module TailwindHelper
  # def to_tw(class_str)
  #   component = class_str.gsub('.',' ') # allow slim . classes
  #   arr = class_str.split(' ') # convert to array
  #   klasses = []
  #   arr.each do |cls|
  #     #see if the cls is defined in component
  #     if TailwindHelper.instance_methods.include?(cls.to_sym)
  #       cls_str = instance_eval(cls) # get the component classes
  #       meth_classes = cls_str.split(' ')
  #       meth_classes.each{|i| klasses << i} # add component classes to klasses
  #     else
  #       klasses << cls # a normal non-component class
  #     end
  #   end
  #   return(klasses.uniq.to_sentence(words_connector:' ',last_word_connector:' '))
  #   # return a sting of classes and any component class
  # end

  def icon(klass, text = '')
    icon_tag = tag.i(class: klass)
    text_tag = tag.span ' ' + text
    text ? tag.span(icon_tag + text_tag) : icon_tag
  end

  def sidebar_menu
    "btn-sqr-blue text-center font-bold border border-zinc-100 py-1"
  end

  # def btn_lg
  #   "mr-2 rounded-xl py-3 px-3 inline-block font-bold text-lg "
  # end

  # def btn_md
  #   "mr-2 rounded-lg py-2 px-3 inline-block font-bold text-md "
  # end

  # def btn_sm
  #   "mr-2 rounded-md py-1 px-3 line-block font-bold text-sm "
  # end
  
  # def btn_submit
  #   "mt-2 rounded-md py-4 px-6 bg-blue-700 text-white hover:bg-blue-600 inline-block font-medium"
  # end

  # def btn_sm_blue
  #   btn_sm + "bg-blue-200 hover:bg-blue-400 "
  # end

  # def btn_sm_red
  #   btn_sm + "bg-red-700 hover:bg-red-800 text-white "
  # end

  # def btn_sm_green
  #   btn_sm + "bg-green-200 hover:bg-green-400 "
  # end

  # def btn_sm_orange
  #   btn_sm + "bg-orange-200 hover:bg-orange-400 "
  # end


  # def btn_lg_green
  #   btn_lg + "bg-green-500 hover:bg-green-400 "
  # end

  # def btn
  #  "mr-2 py-1 px-2 text-black hover:text-white rounded font-lg font-bold "
  # end

  # def btnInfo
  #  btn + "bg-blue-400 text-blue-link hover:text-blue-100 "
  # end

  # def btnWarn
  #  btn + "bg-orange-400 hover:text-yellow-200 "
  # end

  # def btnLink
  #  btn + "bg-green-500 hover:text-green-100 "
  # end

  # def btnDanger
  #  btn + "bg-red-500 hover:text-red-200 "
  # end

  # def btnSuccess
  #  btn + "bg-success hover:bg-green-700 "
  # end

  # def btnPt
  #  btn + "bg-pt-blue text-white "
  # end

  # def btnSubmit
  #   btnLink + "m-1 border-2 border-green-800"
  # end

  # def blueBox
  #   "box-border box-content m-3 p-4 bg-blue-400 border-blue-200 border-2 text-black"
  # end

end
