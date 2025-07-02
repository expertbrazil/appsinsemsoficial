class EffortsController < ApplicationController
  before_action :set_effort, only: [:show, :edit, :update, :destroy]

  # GET /efforts
  # GET /efforts.json
  def index
    @efforts = Effort.paginate(page: params[:page])
  end

  # GET /efforts/1
  # GET /efforts/1.json
  def show
  end

  # GET /efforts/new
  def new
    @effort = Effort.new
  end

  # GET /efforts/1/edit
  def edit
  end

  # POST /efforts
  # POST /efforts.json
  def create
    @effort = Effort.new(effort_params)
    @saved = @effort.save

    respond_to do |format|
      if @saved
        @url =  params[:create_and_add] ? new_effort_url : efforts_url    
        format.html { redirect_to @url, notice: "#{Effort.model_name.human} #{I18n.t('default_messages.created')}" }
        format.json { render :show, status: :created, location: @effort }
        format.js
      else
        format.html { render :new }
        format.json { render json: @effort.errors, status: :unprocessable_entity }
        format.js
      end
    end
  end

  # PATCH/PUT /efforts/1
  # PATCH/PUT /efforts/1.json
  def update
    respond_to do |format|
      if @effort.update(effort_params)
        format.html { redirect_to efforts_url, notice: "#{Effort.model_name.human} #{I18n.t('default_messages.updated')}" }
        format.json { render :show, status: :ok, location: @effort }
      else
        format.html { render :edit }
        format.json { render json: @effort.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /efforts/1
  # DELETE /efforts/1.json
  def destroy
    @effort.destroy
    respond_to do |format|
      format.html { redirect_to efforts_url, notice: "#{Effort.model_name.human} #{I18n.t('default_messages.destroyed')}" }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_effort
      @effort = Effort.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def effort_params
      params.require(:effort).permit(:name, :to_describe)
    end
end
