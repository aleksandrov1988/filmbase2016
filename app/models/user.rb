class User < ActiveRecord::Base
  has_secure_password

ROLES = %w(Пользователь Администратор)

validates :name, presence: true, length: {minimum: 2, maximum: 255}
validates :email, presence: true, uniqueness: {case_sensitive: false},
          format: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
validates :role, presence: true, inclusion: {in: 0..ROLES.size}
validates :password, length: {minimum: 6, if: 'password.present?'}, presence: {on: :create}


before_validation :set_default_role

scope :ordering,->{order(:name)}

def set_default_role
  self.role||=0
end

def role_name
  role && ROLES[role]
end

def admin?
  role == 1
end


  def self.edit_by?(u)
    u.try(:admin?)
  end


end
