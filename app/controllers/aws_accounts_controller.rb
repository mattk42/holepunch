class AwsAccountsController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_aws_account, only: [:show, :edit, :update, :destroy]

  # GET /aws_accounts
  # GET /aws_accounts.json
  def index
    @aws_accounts = AwsAccount.all
  end

  # GET /aws_accounts/1
  # GET /aws_accounts/1.json
  def show
    ec2 = AWS::EC2.new( :access_key_id => @aws_account.access_key, :secret_access_key => @aws_account.secret_key)
    @regions=Hash.new
    ec2.regions.each do |region|
      r_instances = instances_cached ec2,@aws_account.id,region
      if r_instances.count > 0
        @regions[region.name]=r_instances
      end
    end
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
      if @aws_account.update(aws_account_params)
        format.html { redirect_to @aws_account, notice: 'Aws account was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @aws_account.errors, status: :unprocessable_entity }
      end
    end
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
      params.require(:aws_account).permit(:account_id, :name, :access_key, :secret_key)
    end

    def instances_cached(ec2,account_id,region)
	Rails.cache.fetch region, :expires_in => 5.minutes do
		ec2.regions[region.name].instances
	end
    end
end
