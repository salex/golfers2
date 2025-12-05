= turbo_frame_tag "home"
  div.w-full
    p style="color: green" = notice
    - puts "PARAMS #{params.inspect}"
    h1.font-bold.text-2xl ="Visiting Group #{current_group.name} as #{@who}"
    div.italic
      | Click the button below to access the Groups home page.
    div.flex.gap-8
      = link_to icon('fas fa-edit',"Show Home"), root_path,  data:{turbo:false},class:"btn-sm-green"
 