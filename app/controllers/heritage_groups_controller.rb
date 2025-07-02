class HeritageGroupsController < ApplicationController
  before_action :set_heritage_group, only: [:show, :edit, :update, :destroy]

  # GET /heritage_groups
  # GET /heritage_groups.json
  def index
    @heritage_groups = HeritageGroup.all
  end

  # GET /heritage_groups/1
  # GET /heritage_groups/1.json
  def show
  end

  # GET /heritage_groups/new
  def new
    @heritage_group = HeritageGroup.new
  end

  # GET /heritage_groups/1/edit
  def edit
  end

  # POST /heritage_groups
  # POST /heritage_groups.json
  def create
    @heritage_group = HeritageGroup.new(heritage_group_params)

    respond_to do |format|
      if @heritage_group.save
        @url =  params[:create_and_add] ? new_heritage_group_url : heritage_groups_url 
        format.html { redirect_to @url, notice: 'Heritage group was successfully created.' }
        format.json { render :show, status: :created, location: @heritage_group }
      else
        format.html { render :new }
        format.json { render json: @heritage_group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /heritage_groups/1
  # PATCH/PUT /heritage_groups/1.json
  def update
    respond_to do |format|
      if @heritage_group.update(heritage_group_params)
        format.html { redirect_to heritage_groups_url, notice: 'Heritage group was successfully updated.' }
        format.json { render :show, status: :ok, location: @heritage_group }
      else
        format.html { render :edit }
        format.json { render json: @heritage_group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /heritage_groups/1
  # DELETE /heritage_groups/1.json
  def destroy
    @heritage_group.destroy
    respond_to do |format|
      format.html { redirect_to heritage_groups_url, notice: 'Heritage group was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_heritage_group
      @heritage_group = HeritageGroup.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def heritage_group_params
      params.require(:heritage_group).permit(:name)
    end
end
