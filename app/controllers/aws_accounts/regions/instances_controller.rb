class AwsAccounts::Regions::InstancesController < ApplicationController
  before_filter :authenticate_user!

  # GET /aws_accounts/#id/instances/#id
  def show
  	aws_account=AwsAccount.find(params[:aws_account_id])
  	ec2 = AWS::EC2.new( :access_key_id => aws_account.access_key, :secret_access_key => aws_account.secret_key, :region => params[:region_id])
  	@instance=ec2.instances[params[:id]]
  end
end
