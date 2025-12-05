div[class="grid grid-cols-2 md:hidden"]
  - mapping = get_col_mapping(@players.size,2)
  - 2.times do |i|
    div[class=""]
      - mapping[i].each do |m|
        div[class="btn-schedule w-48 h-8" 
           id="#{@players[m].id}" 
           data-scheduler-target='player' 
           data-action="click->scheduler#add_player" 
           data-playerid="#{@players[m].id}"] = @players[m].name[0..20]

div[class="hidden md:grid md:grid-cols-3 lg:hidden"]
  - mapping = get_col_mapping(@players.size,3)
  - 3.times do |i|
    div[class=""]
      - mapping[i].each do |m|
        div[class="btn-schedule w-48 h-8" 
          id="#{@players[m].id}" 
          data-scheduler-target='player' 
          data-action="click->scheduler#add_player" 
          data-playerid="#{@players[m].id}"] = @players[m].name[0..20]

div[class="hidden lg:grid lg:grid-cols-4 "]
  - mapping = get_col_mapping(@players.size,4)
  - 4.times do |i|
    div[class=""]
      - mapping[i].each do |m|
        div[class="btn-schedule w-48 h-8" 
          id="#{@players[m].id}" 
          data-scheduler-target='player' 
          data-action="click->scheduler#add_player" 
          data-playerid="#{@players[m].id}"] = @players[m].name[0..20]
