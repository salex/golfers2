module GroupsHelper
  def linkBtn(prompt,model_path,meth:"",klass:"")
    if meth.blank?
      meth='patch'
    end
    if klass.blank?
      klass = "btn-danger"
    end
    return button_to prompt, model_path, method: meth, form_class:" w-full py-0 ",class:klass
  end

end
