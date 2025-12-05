class Can
  CRUD = {
    super: {
      group: "1111",
      user: "1111",
      player: "1111",
      game: "1111",
      round: "1111",
      article: "1111"

    },
    trustee: {
      group: "0110",
      user: "1111",
      player: "1111",
      game: "1111",
      round: "1111",
      article: "1111"
      
    },
    manager: {
      group: "0110",
      user: "1111",
      player: "1111",
      game: "1111",
      round: "1111",
      article: "1111"
    },
    admin: {
      group: "0100",
      user: "0100",
      player: "1111",
      game: "1111",
      round: "1111",
      article: "1111"
    },
    member: {
      group: "0100",
      user: "0000",
      player: "0100",
      game: "0100",
      round: "0100",
      article: "1111"
    }
  }

  def self.can(role)
    # called from User model - returns user roles
    cans = CRUD[role.downcase.to_sym]
  end

  def self.level(role)
    # index = array.index(30)
    CRUD.keys.index(role.to_sym)
  end

  # below is just testing methods
  def self.crud
    CRUD
  end

  def self.roles
      CRUD.keys.map { |o| o = o.to_s }
    end

  def self.models
    CRUD[:super].keys.map { |o| o = o.to_s }
  end

  # def self.to_yaml
  #   return CRUD.to_yaml
  # end
end
