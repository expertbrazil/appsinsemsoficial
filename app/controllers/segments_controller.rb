class SegmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize, if: :user_signed_in?
  before_action :set_segment, only: [:show, :edit, :update, :destroy]

  # GET /segments
  # GET /segments.json
  def index
    @segments = Segment.paginate(page: params[:page])
  end

  # GET /segments/1
  # GET /segments/1.json
  def show
  end

  # GET /segments/new
  def new
    @segment = Segment.new
  end

  # GET /segments/1/edit
  def edit
  end

  # POST /segments
  # POST /segments.json
  def create
    @segment = Segment.new(segment_params)
    @saved = @segment.save
    
    respond_to do |format|
      if @saved
        @url =  params[:create_and_add] ? new_segment_url : segments_url 
        format.html { redirect_to @url, notice: "#{Segment.model_name.human} #{I18n.t('default_messages.created')}" }
        format.json { render :show, status: :created, location: @segment }
        format.js
      else
        format.html { render :new }
        format.json { render json: @segment.errors, status: :unprocessable_entity }
        format.js
      end
    end
  end

  # PATCH/PUT /segments/1
  # PATCH/PUT /segments/1.json
  def update
    respond_to do |format|
      if @segment.update(segment_params)
        format.html { redirect_to segments_url, notice: "#{Segment.model_name.human} #{I18n.t('default_messages.updated')}" }
        format.json { render :show, status: :ok, location: @segment }
      else
        format.html { render :edit }
        format.json { render json: @segment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /segments/1
  # DELETE /segments/1.json
  def destroy
    @segment.destroy
    respond_to do |format|
      format.html { redirect_to segments_url, notice: "#{Segment.model_name.human} #{I18n.t('default_messages.destroyed')}" }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_segment
      @segment = Segment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def segment_params
      params.require(:segment).permit(:name)
    end
end
