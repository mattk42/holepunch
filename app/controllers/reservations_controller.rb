class ReservationsController < ApplicationController
  load_and_authorize_resource
  before_action :set_reservation, only: [:show, :edit, :update, :destroy]

  # GET /reservations
  # GET /reservations.json
  def index
    @reservations = Reservation.all
  end

  # GET /reservations/1
  # GET /reservations/1.json
  def show
  end

  # GET /reservations/1/edit
  def edit
  end

  def new
    @aws_account = AwsAccount.find(params[:aws_account_id])
    @reservation = Reservation.new
    @reservation.instance_id=params[:instance_id]
    @reservation.region=params[:region_id]
  end

  # POST /reservations
  # POST /reservations.json
  def create
    #Initialize the scheduler we are going to use to remove the reservation
    scheduler = Rufus::Scheduler.new

    #Create the reservation in the DB
    @reservation = Reservation.new(reservation_params)
    @reservation.aws_account_id=params[:aws_account_id]

    #end_time is calculated from the reservation_length field
    @reservation.end_time=DateTime.now + params[:reservation_length].to_i.minutes

    #Turn the source IP address into a CIDR 
    @reservation.ip_address=@reservation.ip_address+"/32"

    #Create the reservation in AWS
    @aws_account = AwsAccount.find(@reservation.aws_account_id)
    ec2 = AWS::EC2.new( :access_key_id => @aws_account.access_key, :secret_access_key => @aws_account.secret_key, :region => @reservation.region)

    security_group=ec2.security_groups.create("holepunch-"+@reservation.instance_id)
    ip_addresses=[@reservation.ip_address]
    if @reservation.end_port != nil
      ports=@reservation.start_port.to_s+".."+@reservation.end_port.to_s
    else
      ports=@reservation.start_port
    end

    security_group.authorize_ingress :tcp, ports, *ip_addresses

    #Schedule deleting the newly created SG
    scheduler.at @reservation.end_time do
        security_group.delete
        @reservation.delete
    end

    respond_to do |format|
      if @reservation.save
        format.html { redirect_to @reservation, notice: 'Reservation was successfully created.' }
        format.json { render action: 'show', status: :created, location: @reservation }
      else
        format.html { render action: 'new' }
        format.json { render json: @reservation.errors, status: :unprocessable_entity }
      end
    end

  end

  # PATCH/PUT /reservations/1
  # PATCH/PUT /reservations/1.json
  def update
    respond_to do |format|
      if @reservation.update(reservation_params)
        format.html { redirect_to instance_path(@reservation.instance_id), notice: 'Reservation was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @reservation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /reservations/1
  # DELETE /reservations/1.json
  def destroy
    @reservation.destroy
    respond_to do |format|
      format.html { redirect_to reservations_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_reservation
      @reservation = Reservation.find(params[:id])
      @aws_account = AwsAccount.find(@reservation.aws_account_id)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def reservation_params
      params.require(:reservation).permit(:user_id, :sg_id, :instance_id, :ip_address, :start_port, :end_port,:region)
    end
end
