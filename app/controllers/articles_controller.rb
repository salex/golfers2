class ArticlesController < ApplicationController
  before_action :require_super, only: [:create, :edit, :update, :destroy]
  before_action :set_article, only: [:show, :edit, :update, :destroy]


  # GET /inquiries
  # GET /inquiries.json

  def index
    @articles = Article.all.order(:date).reverse_order
  end

  # GET /inquiries/1
  # GET /inquiries/1.json
  def show
  end

  # GET /inquiries/new
  def new
    # set_ptgolf
    @article = Article.new(stashable_type:"Golfer",
      stashable_id:1, 
      date:Date.today)
  end

  # GET /inquiries/1/edit
  def edit
  end

  # POST /inquiries
  # POST /inquiries.json
  def create

    @article = Article.new(stashable_type:"Golfer",
      stashable_id:1, 
      date:Date.today)

    respond_to do |format|
      if @article.update(article_params)
        format.html { redirect_to root_path, notice: 'Article was successfully created.' }
        format.json { render :show, status: :created, location: @article }
      else
        format.html { render :new, status: :unprocessable_entity}
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /inquiries/1
  # PATCH/PUT /inquiries/1.json
  def update
    respond_to do |format|
      if @article.update(article_params)
        format.html { redirect_to article_path(@article), notice: 'Article was successfully updated.' }
        format.json { render :show, status: :ok, location: @article }
      else
        format.html { render :edit, status: :unprocessable_entity}
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /inquiries/1
  # DELETE /inquiries/1.json
  def destroy
    @article.destroy
    respond_to do |format|
      format.html { redirect_to article_url, notice: 'Article was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def require_super
      cant_do_that(' - Not Authorized') unless is_super?
    end

    def set_article
      @article = Article.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def article_params
      params.require(:article).permit(:title,:content,:date,:slim,:date,:status,:stashable_id, :stashable_type)

    end
end
