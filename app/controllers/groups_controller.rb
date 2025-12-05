class GroupsController < ApplicationController
  before_action :require_group, except: %i[visit]

  before_action :require_super, only: %i[ new create]
  before_action :require_admin, only: %i[edit update expired_players]
  before_action :require_member, except: %i[show visit leave stats stats_refresh]

  before_action :set_group, only: %i[ show edit update destroy visit expired_players]

  # GET /groups or /groups.json
  def index
      @groups = Group.all.order(:id)
  end

  # GET /groups/1 or /groups/1.json
  def show
    if is_super?
      @group = Group.find_by(id:params[:id])
      cant_do_that(' - Group  not found') unless @group.present? 
    else
      @group = current_group
    end
  end

  # GET /groups/new
  def new
    @group = Group.new
  end

  # GET /groups/1/edit
  def edit
    if current_user.is_super?
      @group = Group.find(params[:id])
    else
      @group = current_group
    end

  end

  # POST /groups or /groups.json
  def create
    @group = Group.new(group_params)

    respond_to do |format|
      if @group.update_group(group_params)
        format.html { redirect_to group_url(@group), notice: "Group was successfully created." }
        format.json { render :show, status: :created, location: @group }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /groups/1 or /groups/1.json
  def update
    respond_to do |format|
      # puts "PPPPPPP #{group_params}"
      if @group.update_group(group_params)
        format.html { redirect_to group_url(@group), notice: "Group was successfully updated." }
        format.json { render :show, status: :ok, location: @group }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  def login(user)
    Current.user = user
    reset_session
    session[:group_id] = user.group_id
    session[:user_id] = user.id
    session[:fullname] = user.fullname
    session[:expires] = Time.now + 60.minutes
    Current.group = Current.user.group
  end

  def leave
    reset_session
    redirect_to root_path, notice:"Exit Group"
  end
  
  def visit
    if is_trustee?
      @group = Group.find(params[:id])
      session[:group_id] = @group.id
      Current.group = @group
      # puts "#{@who} VISIT GROUP #{@group.id}"
      redirect_to root_path, notice:"Welcome to group #{@group.name}"
    else
      @group = Group.find(params[:id])
      @who="Visitor"
      reset_session
      session[:group_id] = @group.id
      session[:fullname] = @who
      session[:expires] = Time.now + 15.minutes
      redirect_to root_path, notice:"Welcome to group #{@group.name}"
    end
  end

  # DELETE /groups/1 or /groups/1.json
  def destroy
    @group.destroy!

    respond_to do |format|
      format.html { redirect_to groups_url, notice: "Group was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def stats
    Current.group = current_group
    @group=Current.group
    @groupStats = GroupStats.new
  end

  def stats_refresh
    @groupStats = GroupStats.new(params[:stats])
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.replace('refresh', partial: 'groups/stats_refresh')}
      format.html { render :template => 'groups/stats'}
    end
  end

  def expired_players
    @expired = @group.expired_players
  end

  def trim_expired
    set_group
    players = @group.players.find(params[:deleted]).pluck(:name)
    @group.players.find(params[:deleted]).each{|p| p.delete}
    redirect_to expired_players_group_path(@group), notice: "Player(s) #{players} have been deleted!"
  end

  def recompute_quotas
    set_group
    @group.recompute_group_quotas
    redirect_to root_url, notice: "Group Quotas have be recomputed!"
  end

  def trim_rounds
    set_group
    @group.trim_rounds
    redirect_to root_url, notice: "Group Events/Rounds over #{@group.trim_months} months old have be deleted and quotas recomputed"
  end

  private
    def require_group
      cant_do_that(' - Not Authorized') unless current_group.present?
    end
    def require_super
      cant_do_that(' - Not Authorized') unless is_super?
    end
    def require_admin
      cant_do_that(' - Not Authorized') unless current_user && current_user.is_admin?
    end
    def require_member
      cant_do_that(' - Not Authorized') unless current_user && current_user.is_member?
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_group
      @group = current_group
    end

    # Only allow a list of trusted parameters through.
    def group_params
      params.require(:group).permit(:name, :tees,:courses,@group.default_settings.keys)
    end
end
