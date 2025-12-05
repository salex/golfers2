class GamesController < ApplicationController
  before_action :require_group
  before_action :set_game, only: %i[ show edit update destroy ]

  # GET /games or /games.json
  def index
    # @games = current_group.games.order(:date).limit(20).reverse_order
    # @pagy, @records = pagy(Product.some_scope, items: 30)
    @pagy, @games = pagy(current_group.games.order(:date).reverse_order, items: 12)


  end

  # GET /games/1 or /games/1.json
  def show
  end

  # GET /games/new
  def new
    @game = current_group.games.build(status:'scheduled',date:Date.today)
  end

  # GET /games/1/edit
  def edit
  end

  # POST /games or /games.json
  def create
    @game = Game.new(game_params)

    respond_to do |format|
      if @game.save
        format.html { redirect_to game_url(@game), notice: "Game was successfully created." }
        format.json { render :show, status: :created, location: @game }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /games/1 or /games/1.json
  def update
    respond_to do |format|
      if @game.update(game_params)
        format.html { redirect_to game_url(@game), notice: "Game was successfully updated." }
        format.json { render :show, status: :ok, location: @game }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /games/1 or /games/1.json
  def destroy
    @game.destroy!

    respond_to do |format|
      format.html { redirect_to games_url, notice: "Game was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def new_today
    @game = current_group.games.build(date:Date.today,method:current_group.pay,
      status:'Scheduled',course:current_group.default_course)
    respond_to do |format|
      if @game.save
        format.html { redirect_to @game.namespace_url, notice: 'Game for today was successfully created' }
        format.json { render :show, status: :created, location: @game }
      else
        format.html { render :new, status: :unprocessable_entity}
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end


  private
     def require_group
       cant_do_that(' - Not Authorized') unless current_group.present?
     end

    # Use callbacks to share common setup or constraints between actions.
    def set_game
      @game = current_group.games.find_by(id:params[:id])
      cant_do_that(' - Game not found') unless @game.present?
    end

    # Only allow a list of trusted parameters through.
    def game_params
      params.require(:game).permit(:group_id, :date, :status, :method, :formed, :par3, :skins, :course)
    end
end
