class DepartmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize, if: :user_signed_in?
  before_action :set_department, only: [:show, :edit, :update, :destroy]

  # GET /departments
  # GET /departments.json
  def index
    @departments = Department.paginate(page: params[:page])
  end

  # GET /departments/1
  # GET /departments/1.json
  def show
  end

  # GET /departments/new
  def new
    @department = Department.new
  end

  # GET /departments/1/edit
  def edit
  end

  # POST /departments
  # POST /departments.json
  def create
    @department = Department.new(department_params)
    @saved = @department.save

    respond_to do |format|
      if @saved
        @url =  params[:create_and_add] ? new_department_url : departments_url  
        format.html { redirect_to @url, notice: "#{Department.model_name.human} #{I18n.t('default_messages.created')}" }
        format.json { render :show, status: :created, location: @department }
        format.js
      else
        format.html { render :new }
        format.json { render json: @department.errors, status: :unprocessable_entity }
        format.js
      end
    end
  end

  # PATCH/PUT /departments/1
  # PATCH/PUT /departments/1.json
  def update
    respond_to do |format|
      if @department.update(department_params)
        format.html { redirect_to departments_url, notice: "#{Department.model_name.human} #{I18n.t('default_messages.updated')}" }
        format.json { render :show, status: :ok, location: @department }
      else
        format.html { render :edit }
        format.json { render json: @department.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /departments/1
  # DELETE /departments/1.json
  def destroy
    @department.destroy
    respond_to do |format|
      format.html { redirect_to departments_url, notice: "#{Department.model_name.human} #{I18n.t('default_messages.destroyed')}" }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_department
      @department = Department.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def department_params
      params.require(:department).permit(:name, :description)
    end
end
