class AwsAccount < ActiveRecord::Base
	attr_accessible :name, :access_key, :secret_key, :default_region
end
