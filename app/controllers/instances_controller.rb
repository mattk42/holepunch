class InstancesController < ApplicationController
  def show
    aws_account=AwsAccount.find(params[:aws_account_id])
    ec2 = AWS::EC2.new( :access_key_id => aws_account.access_key, :secret_access_key => aws_account.secret_key, :region => params[:region_id])
    @instance=ec2.instances[params[:id]]	
    @reservations = Reservation.where(:instance_id=>@instance.id)
  end

  private
    #Never trust parameters from the scary internet, only allow the white list through.
    def instance_params 
      params.require(:instance,:aws_account,:region).permit()
    end

end
