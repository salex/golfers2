class UsersController < ApplicationController
  before_action :require_admin, only: %i[index show edit update destroy ]
  before_action :set_user, only: %i[ show edit update destroy ]

  # GET /users or /users.json
  def index
    if is_super?
      @users = User.all.includes(:group).order(:fullname).order(:fullname)
    elsif is_trustee?
      @users = User.all.includes(:group).where.not(role:'super').order(:fullname)
    elsif is_manager?
      @users = Current.group.users.where.not(role:'super').where.not(role:'trustee').order(:fullname)
    else
      cant_do_that
    end
   end

  # GET /users/1 or /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = current_group.users.new(role:User::Roles.last)
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users or /users.json
  def create
    @user = User.new(user_params)
    # @user.permits = DefaultPermits::CRUD[@user.role.to_sym]
    respond_to do |format|
      if @user.save
        format.html { redirect_to user_url(@user), notice: "User was successfully created." }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1 or /users/1.json
  def update
    curr_role = @user.role
    # puts "CURR ROLE #{curr_role}"
    respond_to do |format|
      if @user.update(user_params)
        # puts "CURR ROLE #{curr_role} NEW ROLE #{@user.role} #{@user.role != curr_role}"
        # if @user.role.nil? || (@user.role != curr_role) # role changed - may be a better way
        #   @user.permits = DefaultPermits::CRUD[@user.role.to_sym]
        #   @user.save
        # end
        format.html { redirect_to user_url(@user), notice: "User was successfully updated." }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1 or /users/1.json
  def destroy
    @user.destroy!
    respond_to do |format|
      format.html { redirect_to users_url, notice: "User was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    def require_admin
      cant_do_that(' - Not Authorized') unless current_user && current_user.is_manager?
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])

      if is_trustee?
        @user = User.find(params[:id])
      else
        @user = current_group.users.find(params[:id])
      end
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:group_id, :fullname, :username, :email, :role, :permits, :password, :password_confirmation)
    end
end
