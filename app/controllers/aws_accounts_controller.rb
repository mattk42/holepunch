class AwsAccountsController < ApplicationController
  load_and_authorize_resource
  before_filter :authenticate_user!
  before_action :set_aws_account, only: [:show, :refresh, :edit, :update, :destroy, :instances]

  # GET /aws_accounts
  # GET /aws_accounts.json
  def index
    @aws_accounts = AwsAccount.where(:account_id=>current_user.account_id)
  end
  # GET /aws_accounts/1.json
  def show

    # If no region is selected, use default region. If none set, us-west-1
    if params[:region] == nil
      if @aws_account.default_region != nil
        params[:region] = @aws_account.default_region
      else
        params[:region] = "us-west-1"
      end
    end 

    AWS.start_memoizing
    ec2 = AWS::EC2.new( :access_key_id => @aws_account.access_key, :secret_access_key => @aws_account.secret_key, :region => params[:region])
    @regions = ec2.regions

    @instances = ec2.instances
  end

  # GET /aws_accounts/new
  def new
    @aws_account = AwsAccount.new
  end

  # GET /aws_accounts/1/edit
  def edit
  end

  # POST /aws_accounts
  # POST /aws_accounts.json
  def create
    @aws_account = AwsAccount.new(aws_account_params)
    @aws_account.account_id=current_user.account_id

    respond_to do |format|
      if @aws_account.save
        format.html { redirect_to @aws_account, notice: 'Aws account was successfully created.' }
        format.json { render action: 'show', status: :created, location: @aws_account }
      else
        format.html { render action: 'new' }
        format.json { render json: @aws_account.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /aws_accounts/1
  # PATCH/PUT /aws_accounts/1.json
  def update
    respond_to do |format|
      logger.info(aws_account_params) 
      if @aws_account.update(aws_account_params)
        format.html { redirect_to @aws_account, notice: 'Aws account was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @aws_account.errors, status: :unprocessable_entity }
      end
    end
  end

  #GET /aws_accounts/1/instanes/i-1ie9382
  def instances
    AWS.start_memoizing
    ec2 = AWS::EC2.new( :access_key_id => @aws_account.access_key, :secret_access_key => @aws_account.secret_key, :region => params[:region_id])
    @instance=ec2.instances[params[:instance_id]]  
    @reservations = Reservation.where(:instance_id=>@instance.id)
  end

  # DELETE /aws_accounts/1
  # DELETE /aws_accounts/1.json
  def destroy
    @aws_account.destroy
    respond_to do |format|
      format.html { redirect_to aws_accounts_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_aws_account
      @aws_account = AwsAccount.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def aws_account_params
      params.require(:aws_account).permit(:account_id, :name, :access_key, :secret_key, :default_region, :instance_id)
    end

end
