class User < ActiveRecord::Base
  has_many :reservations, :dependent=>:destroy
  has_many :tags, :dependent=>:destroy
  belongs_to :account, :inverse_of => :users
  validates :account, :presence => true
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :timeoutable
  attr_accessible :email, :password, :password_confirmation, :remember_me, :account_id
end