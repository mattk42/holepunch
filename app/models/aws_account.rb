class AwsAccount < ActiveRecord::Base
	has_many :reservations, :dependent => :destroy
	attr_accessible :name, :access_key, :secret_key, :default_region
end
