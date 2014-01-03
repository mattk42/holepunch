class Account < ActiveRecord::Base
  has_many :users, :inverse_of => :account, :dependent => :destroy
  has_many :aws_accounts, :dependent => :destroy
  accepts_nested_attributes_for :users
  attr_accessible :name, :users, :users_attributes
end
