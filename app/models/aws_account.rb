class AwsAccount < ActiveRecord::Base
	has_many :reservations
	attr_accessible :name, :access_key, :secret_key, :default_region
end
