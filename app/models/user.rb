class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :role_id
  # attr_accessible :title, :body

  belongs_to :role
  has_many :products, foreign_key: 'creator_id'

  scope :admins, -> { joins(:role).where(roles: {name: 'Admin'}) }

  def customer?
    role.name == 'Customer'
  end

  def admin?
    role.name == 'Admin'
  end
end
