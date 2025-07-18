class OccupationsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize, if: :user_signed_in?
  before_action :set_occupation, only: [:show, :edit, :update, :destroy]

  # GET /occupations
  # GET /occupations.json
  def index
    @occupations = Occupation.paginate(page: params[:page])
  end

  # GET /occupations/1
  # GET /occupations/1.json
  def show
  end

  # GET /occupations/new
  def new
    @occupation = Occupation.new
  end

  # GET /occupations/1/edit
  def edit
  end

  # POST /occupations
  # POST /occupations.json
  def create
    @occupation = Occupation.new(occupation_params)
    @saved = @occupation.save

    respond_to do |format|
      if @saved
        @url =  params[:create_and_add] ? new_occupation_url : occupations_url  
        format.html { redirect_to @url, notice: "#{Occupation.model_name.human} #{I18n.t('default_messages.created')}" }
        format.json { render :show, status: :created, location: @occupation }
        format.js
      else
        format.html { render :new }
        format.json { render json: @occupation.errors, status: :unprocessable_entity }
        format.js
      end
    end
  end

  # PATCH/PUT /occupations/1
  # PATCH/PUT /occupations/1.json
  def update
    respond_to do |format|
      if @occupation.update(occupation_params)
        format.html { redirect_to occupations_url, notice: "#{Occupation.model_name.human} #{I18n.t('default_messages.updated')}" }
        format.json { render :show, status: :ok, location: @occupation }
      else
        format.html { render :edit }
        format.json { render json: @occupation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /occupations/1
  # DELETE /occupations/1.json
  def destroy
    @occupation.destroy
    respond_to do |format|
      format.html { redirect_to occupations_url, notice: "#{Occupation.model_name.human} #{I18n.t('default_messages.destroyed')}"  }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_occupation
      @occupation = Occupation.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def occupation_params
      params.require(:occupation).permit(:name)
    end
end
