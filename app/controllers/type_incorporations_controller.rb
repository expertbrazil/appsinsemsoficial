class TypeIncorporationsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize, if: :user_signed_in?
  before_action :set_type_incorporation, only: [:show, :edit, :update, :destroy]

  # GET /type_incorporations
  # GET /type_incorporations.json
  def index
    @type_incorporations = TypeIncorporation.paginate(page: params[:page])
  end

  # GET /type_incorporations/1
  # GET /type_incorporations/1.json
  def show
  end

  # GET /type_incorporations/new
  def new
    @type_incorporation = TypeIncorporation.new
  end

  # GET /type_incorporations/1/edit
  def edit
  end

  # POST /type_incorporations
  # POST /type_incorporations.json
  def create
    @type_incorporation = TypeIncorporation.new(type_incorporation_params)
    @saved = @type_incorporation.save

    respond_to do |format|
      if @saved
        format.html { redirect_to type_incorporations_url, notice: "#{TypeIncorporation.model_name.human} #{I18n.t('default_messages.created')}" }
        format.json { render :show, status: :created, location: @type_incorporation }
        format.js
      else
        format.html { render :new }
        format.json { render json: @type_incorporation.errors, status: :unprocessable_entity }
        format.js
      end
    end
  end

  # PATCH/PUT /type_incorporations/1
  # PATCH/PUT /type_incorporations/1.json
  def update
    respond_to do |format|
      if @type_incorporation.update(type_incorporation_params)
        format.html { redirect_to type_incorporations_url, notice: "#{TypeIncorporation.model_name.human} #{I18n.t('default_messages.updated')}" }
        format.json { render :show, status: :ok, location: @type_incorporation }
      else
        format.html { render :edit }
        format.json { render json: @type_incorporation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /type_incorporations/1
  # DELETE /type_incorporations/1.json
  def destroy
    @type_incorporation.destroy
    respond_to do |format|
      format.html { redirect_to type_incorporations_url, notice: "#{TypeIncorporation.model_name.human} #{I18n.t('default_messages.destroyed')}" }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_type_incorporation
      @type_incorporation = TypeIncorporation.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def type_incorporation_params
      params.require(:type_incorporation).permit(:name, :to_describe)
    end
end
