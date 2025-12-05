div 
  / = turbo_frame_tag "home"
  div.w-full
    / p style="color: green" = notice
    h1.font-bold.text-2xl Visiting Group
    div.italic
      | until i figure out how to fix this. Click the button below the click the home button in the index page
    div.flex.gap-8
      / = button_to icon('fas fa-edit',"Show Home"), root_path, method: :get,class:"btn-sm-green"
      = link_to 'Refresh page', root_path

