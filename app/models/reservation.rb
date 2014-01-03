class Reservation < ActiveRecord::Base
	belongs_to :user
	attr_accessible :aws_account_id,:instance_id,:region,:ip_address,:start_port,:end_port,:end_time,:reservation_length,:protocol,:sg_id,:user_id

	before_destroy{
		aws_account = AwsAccount.find(self.aws_account_id)
		ec2 = AWS::EC2.new( :access_key_id => aws_account.access_key, :secret_access_key => aws_account.secret_key, :region => self.region)

		logger.info self.sg_id
		logger.info self.start_port
		logger.info self.ip_address
		
		security_group=ec2.security_groups[self.sg_id]

		ip_addresses=[self.ip_address]
		if self.end_port != nil
		ports=self.start_port..self.end_port
		else
		ports=self.start_port
		end

		security_group.revoke_ingress :tcp, ports, *ip_addresses
	}

end
