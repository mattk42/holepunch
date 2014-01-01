class Reservation < ActiveRecord::Base
	belongs_to :aws_account
	attr_accessible :aws_account_id,:instance_id,:region,:ip_address,:start_port,:end_port,:end_time,:reservation_length
end
