class WorkplacesController < ApplicationController
  before_action :authenticate_user!
  # before_action :authorize, if: :user_signed_in?
  before_action :set_workplace, only: [:show, :edit, :update, :destroy]

  # GET /workplaces
  # GET /workplaces.json
  def index
    @workplaces = Workplace.paginate(page: params[:page])
  end

  # GET /workplaces/1
  # GET /workplaces/1.json
  def show
  end

  # GET /workplaces/new
  def new
    @workplace = Workplace.new
  end

  # GET /workplaces/1/edit
  def edit
  end

  # POST /workplaces
  # POST /workplaces.json
  def create
    @workplace = Workplace.new(workplace_params)
    @saved = @workplace.save
    respond_to do |format|
      if @saved
        @url =  params[:create_and_add] ? new_workplace_url : workplaces_url 

        format.html { redirect_to @url, notice: "#{Workplace.model_name.human} #{I18n.t('default_messages.created')}" }
        format.json { render :show, status: :created, location: @workplace }
        format.js
      else
        format.html { render :new }
        format.json { render json: @workplace.errors, status: :unprocessable_entity }
        format.js
      end
    end
  end

  # PATCH/PUT /workplaces/1
  # PATCH/PUT /workplaces/1.json
  def update
    respond_to do |format|
      if @workplace.update(workplace_params)
        format.html { redirect_to @workplace, notice: "#{Workplace.model_name.human} #{I18n.t('default_messages.updated')}" }
        format.json { render :show, status: :ok, location: @workplace }
      else
        format.html { render :edit }
        format.json { render json: @workplace.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /workplaces/1
  # DELETE /workplaces/1.json
  def destroy
    @workplace.destroy
    respond_to do |format|
      format.html { redirect_to workplaces_url, notice: "#{Workplace.model_name.human} #{I18n.t('default_messages.destroyed')}"  }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_workplace
      @workplace = Workplace.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def workplace_params
      params.require(:workplace).permit(:name)
    end
end
