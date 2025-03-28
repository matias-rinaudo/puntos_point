class Role < ActiveRecord::Base
  attr_accessible :name

  has_one :user

  validates :name, presence: true
end
