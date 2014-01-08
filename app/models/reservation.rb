class Reservation < ActiveRecord::Base
	belongs_to :user
	attr_accessible :aws_account_id,:instance_id,:region,:ip_address,:start_port,:end_port,:end_time,:reservation_length,:protocol,:sg_id,:user_id,:deleted_by,:deleted_date,:deleted

	def destroy 
		#Get the aws account connection and security group. If any of this fails the destroy will fail and never update the deleted column in the database, so it will be attempted again later.
		aws_account = AwsAccount.find(self.aws_account_id)
		ec2 = AWS::EC2.new( :access_key_id => aws_account.access_key, :secret_access_key => aws_account.secret_key, :region => self.region)
		security_group=ec2.security_groups[self.sg_id]

		#Format the reservation parameters for the API query.
		ip_addresses=[self.ip_address]
		if self.end_port != nil
			ports=self.start_port..self.end_port
		else
			ports=self.start_port
		end
		
		#Remove the rule from the security group. This is in a try/catch so that we can log any errors that occur
		security_group.revoke_ingress :tcp, ports, *ip_addresses

		#If the delete was succesful, mark the reservation as deleted but keep the record around for history
		self.deleted_time=DateTime.now
		self.deleted=true
		self.save!
	end

	def delete
		self.destroy
	end
end
