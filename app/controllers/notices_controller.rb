class NoticesController < ApplicationController
  before_action :require_super
  before_action :set_notice, only: [:show, :edit, :update, :destroy, :display]


  # GET /inquiries
  # GET /inquiries.json

  def index
    @notices = Notice.all
  end

  # GET /inquiries/1
  # GET /inquiries/1.json
  def show
  end

  # GET /inquiries/new
  def new
    # set_ptgolf
    @notice = Notice.new(stashable_type:"Golfer",
      stashable_id:1, 
      date:Date.today,due_date:Date.today+3.day)
  end

  # GET /inquiries/1/edit
  def edit
  end

  # POST /inquiries
  # POST /inquiries.json
  def create

    @notice = Notice.new

    respond_to do |format|
      if @notice.update(notice_params)
        format.html { redirect_to root_path, notice: 'Notice was successfully created.' }
        format.json { render :show, status: :created, location: @notice }
      else
        format.html { render :new, status: :unprocessable_entity}
        format.json { render json: @notice.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /inquiries/1
  # PATCH/PUT /inquiries/1.json
  def update
    respond_to do |format|
      if @notice.update(notice_params)
        format.html { redirect_to notice_path(@notice), notice: 'Notice was successfully updated.' }
        format.json { render :show, status: :ok, location: @notice }
      else
        format.html { render :edit, status: :unprocessable_entity}
        format.json { render json: @notice.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /inquiries/1
  # DELETE /inquiries/1.json
  def destroy
    @notice.destroy
    respond_to do |format|
      format.html { redirect_to notices_url, notice: 'Notice was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def display
    # puts "Shoul dispay notice #{params[:id]}"
    @notice = Notice.find(params[:id])
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def require_super
      cant_do_that(' - Not Authorized') unless is_super?
    end

    def set_notice
      @notice = Notice.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def notice_params
      params.require(:notice).permit(:date,:slim,:due_date,:status,:stashable_id, :stashable_type)

    end
end
