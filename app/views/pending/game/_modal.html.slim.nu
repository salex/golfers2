= form_with(url: @game.namespace_url, 
  method: :patch, html:{id:"update_participants"},
  data:{scheduler_target:"form"},
  class:"w-[18rem]" )do |f|
  button.btn.btn-submit.inline-block.w-full[data-scheduler-target="updatep" data-action="click->scheduler#submit" style="display:none;"] Update Current Players

  table.golfer id="current_members"
    caption
      strong Current Players

    thead[data-controller="sortTable"]
      tr
        th Del
        th[data-action="click->sortTable#sortBy" data-stype="T"]
          i.fas.fa-sort.noprint
          |Name
        th.numeric[data-action="click->sortTable#sortBy" data-stype="N"]
          i.fas.fa-sort.noprint
          |RQ

        th Tee
        / th[data-stype="N" data-action="click->sortTable#sortBy"]
        /   i.fas.fa-sort.noprint
        /   |TM

    -  @game.current_players_name.each do |p|
      tr
        <!-- [data-scheduler-target="players"] -->
        td = check_box_tag "deleted[]", value=p.id,nil,data:{action:'scheduler#update_player'}
        td = p.player.name
        td = p.player.rquota_limited
        td.bg-green-100.select = select_tag 'tee[]', tee_options(@game.group,p,true), class:"border border-green-500 select",data:{action:'scheduler#update_player'}
        / td = p.team
  div.italic Instuctions: If you check a Del checkbox or change a tee, the update button will appear. You can delete the player or change the tee by clicking the update button.

  / = f.submit('Update Game', id:'commit',data:{schedule_target:'submit'},style:'display:none;')
  #new_players

