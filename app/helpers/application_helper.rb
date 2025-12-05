module ApplicationHelper
  include Pagy::Frontend
  def inspect_session
    inspect = {}
    session.keys.each do |k|
      inspect[k] = session[k]
    end
    inspect
  end
  alias session_inspect inspect_session

  def slim_text(text)
    page =  Slim::Template.new{|t| text}
    page.render.html_safe
  end

  def markdown_text(text)
    if text.include?(".slim")
      slim_text(text)
      # render inline:text, type: :slim
      # puts " I GOT SLIME TEXT AND REDEERE IT"
    else
      options = {
        :autolink => true,
        :space_after_headers => true,
        :fenced_code_blocks => true,
        :no_intra_emphasis => true
      }
      markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, options)
      markdown.render(text).html_safe
    end
  end

  def destroyTag(model_path,meth:"",confirm_msg:"",klass:"",prompt:"")
    klass= "btn-warn py-0 inline-block mr-1" if klass.blank?
    confirm_msg = "Are You Sure?" if confirm_msg.blank?
    meth = "delete" if meth.blank?
    if prompt.blank?
      url_type = model_path.class
      if url_type == String
        prompt = "Delete"
      else
        prompt = "Delete #{model_path.class.name}"
      end
    end
    # puts "KLASS #{klass}"
    return button_to prompt, model_path, method: meth,form_class:klass,
      form: { data: { turbo_confirm: confirm_msg }}
  end



end
