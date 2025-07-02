class CategoriesController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize, if: :user_signed_in?
  before_action :set_category, only: [:show, :edit, :update, :destroy]
  before_action :set_parent, except: [ :index, :create ]


  # GET /categories
  # GET /categories.json
  def index
    @categories = Category.paginate(page: params[:page])
  end

  # GET /categories/1
  # GET /categories/1.json
  def show
  end

  # GET /categories/new
  def new
    @category = Category.new
    @categories = Category.all
    @to = params[:to].to_i if params[:to].present?
    @bills_pay = params[:bills_pay] if params[:bills_pay].present?
    @bills_receive = params[:bills_receive] if params[:bills_receive].present?
  end

  # GET /categories/1/edit
  def edit
    @categories = Category.where("id != ?", @category.id)
  end

  # POST /categories
  # POST /categories.json
  def create
    @category = Category.new(category_params)
    @saved = @category.save
    @to = params[:category][:to].to_i if params[:category].present? && params[:category][:to].present?
    @bills_pay_id = params[:category][:bills_pay] if params[:category].present? && params[:category][:bills_pay].present?
    @bills_receive_id = params[:category][:bills_receive] if params[:category].present? && params[:category][:bills_receive].present?

    @bills_pay = @bills_pay_id.nil? ? BillsPay.new : BillsPay.find(@bills_pay_id)
    @bills_receife = @bills_receive_id.nil? ? BillsReceife.new : BillsReceife.find(@bills_receive_id)

    respond_to do |format|
      if @saved
        @url =  params[:create_and_add] ? new_category_url : categories_url  
        format.html { redirect_to @url, notice: "#{Category.model_name.human} #{I18n.t('default_messages.created')}" }
        format.json { render :show, status: :created, location: @category }
        format.js
      else
        format.html { render :new }
        format.json { render json: @category.errors, status: :unprocessable_entity }
        format.js
      end
    end
  end

  # PATCH/PUT /categories/1
  # PATCH/PUT /categories/1.json
  def update
    respond_to do |format|
      if @category.update(category_params)
        format.html { redirect_to categories_url, notice: "#{Category.model_name.human} #{I18n.t('default_messages.updated')}" }
        format.json { render :show, status: :ok, location: @category }
      else
        format.html { render :edit }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /categories/1
  # DELETE /categories/1.json
  def destroy
    @category.destroy
    respond_to do |format|
      format.html { redirect_to categories_url, notice: "#{Category.model_name.human} #{I18n.t('default_messages.destroyed')}" }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_category
      @category = Category.find(params[:id])
    end
    
    def set_parent
      @token = (params[:parent_id].present? ? params[:parent_id] : (@category ? @category.parent_id : nil))
      @parent = Category.find(@token) if @token.present?
    end

    # Only allow a list of trusted parameters through.
    def category_params
      params.require(:category).permit(:reduced_code, :parent_id, :type_subcategory, :subcategory_id, :name, :status)
    end
end
