class User < ApplicationRecord
  Roles = %w(super trustee manager admin  member)
  has_secure_password

  belongs_to :group
  # generates_token_for :password_reset, expires_in: 15.minutes do
  #  # Last 10 characters of password salt, which changes when password is updated:
  #  password_salt&.last(10)
  # end

  normalizes :email, with: -> email { email.strip.downcase }
  validates_presence_of :email
  validates_uniqueness_of :username, :allow_blank => true, scope: :group_id
  validates_uniqueness_of :email, :case_sensitive => false, scope: :group_id

  validates_format_of :username, :with => /[-\w\._@]+/i, :allow_blank => true, :message => "should only contain letters, numbers, or .-_@"
  before_save :downcase_login

  def downcase_login
   self.email.downcase!
  end
  attribute :permits

  after_initialize :set_attributes

  def set_attributes
    self.permits = Can.can(self.role) unless self.role.blank?
  end

  def can?(action, model)
    return false if self.role.nil? || self.permits.nil?
    action = action.to_s.downcase
    model = model.to_s.downcase
    permit = permits[model.to_sym]
    return false if permit.nil?

    if [ "create", "new" ].include?(action)
      permit[0] == "1"
    elsif [ "index", "show", "read" ].include?(action)
      permit[1] == "1"
    elsif [ "edit", "update" ].include?(action)
      permit[2] == "1"
    elsif [ "delete", "destroy" ].include?(action)
      permit[3] == "1"
    else
      false
    end
  end

  # Role checkers, from low of member to high of super
  def level?
    Can.level(self.role)
  end

  def is_super?
    return has_role?(['super']) || self.username == 'salex'
  end

  def is_trustee?
    return has_role?(%w(super trustee))
  end

  def is_manager?
    return has_role?(%w(super trustee manager))
  end

  def is_admin?
    return has_role?(%w(super trustee manager admin))
  end

  def is_member?
    return has_role?(%w(super trustee manager admin member))
  end

  def has_role?(role_arr)
    # new simplified role based access. role_arr is always an array
    # self.role should be a string with one word but will take more
    # will work with underutilized haml or json left in roles
    return false if self.role.blank?
    return false if role_arr.class != Array
    return role_arr.include?(self.role)
  end
  # # scp -r /Users/salex/work/rails/users rails@167.71.240.205:/home/rails/apps/myusers

end
