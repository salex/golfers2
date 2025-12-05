class DefaultPermits
  Courses = {
    tb_main:{
      par_in:'443455434',
      par_out:'453445344',
      tees:'gold Blue White Gray Red Junior other'
      },
    tb_par3:{
      par_in:'333333333',
      par_out:'333333333',
      tees:'Par3'
    }
  }
  
  CRUD = {
    super:{
      group:'1111',
      user:'1111',
      player:'1111',
      game:'1111',
      round:'1111',
      article:'1111',
      comment:'1111'
    },
    manager:{
      group:'0110',
      user:'1111',
      player:'1111',
      game:'1111',
      round:'1111',
      article:'0100',
      comment:'1111'
    },
    admin:{
      group:'0110',
      user:'0110',
      player:'1111',
      game:'1111',
      round:'1111',
      article:'0100',
      comment:'1111'
    },
    trustee:{
      group:'0100',
      user:'0110',
      player:'1111',
      game:'1111',
      round:'1111',
      article:'0100',
      comment:'1111'
    },
    member:{
      group:'0100',
      user:'0000',
      player:'0100',
      game:'0100',
      round:'0100',
      article:'0100',
      comment:'1111'
    },
    guest:{
      group:'0100',
      user:'0000',
      player:'0100',
      game:'0100',
      round:'0100',
      article:'0100',
      comment:'0100'
    }
  }

  # def self.permit(role,model,crud)
  #   permits = [:create,:read,:update,:destroy]
  #   urole = CRUD[role.to_sym]
  #   return false unless urole.present?
  #   # puts "ROLE good"
  #   umodel = urole[model.to_sym]
  #   return false unless model.present?
  #   # puts "MODEL good"
  #   ucrud= crud.to_sym
  #   return false unless permits.include?(ucrud)
  #   # puts "CRUD good"
  #   idx = permits.index(ucrud)
  #   # puts "IDX #{idx} #{umodel} "
  #   return false if idx.nil?
  #   return umodel[idx] == '1'
  #   # puts upermit
  #   # return ucrud[val]
  #   # if crud[val] == '1' ? return true : return false
  # end

  def self.permit(role,model)
    urole = CRUD[role.downcase.to_sym]
    return false unless urole.present?
    umodel = urole[model.downcase.to_sym]
    return false unless umodel.present?
    return umodel
  end



  def crud
    return CRUD
  end

  def roles
      return CRUD.keys.map{|o| o = o.to_s}
    end

  def models
    return CRUD[:super].keys.map{|o| o = o.to_s}
  end
  
end