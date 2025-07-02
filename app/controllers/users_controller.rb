class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize, except: [:edit_profile, :update_profile], if: :user_signed_in?
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def index
    @users = User.paginate(page: params[:page])
  end

  def edit

  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        @url =  params[:create_and_add] ? new_user_url : users_url 
        format.html { redirect_to @url, notice: "#{User.model_name.human} #{I18n.t('default_messages.created')}" }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    if user_params[:password].blank?
      user_params.delete(:password)
      user_params.delete(:password_confirmation)
    end

    active_was = @user.active_was
    successfully_updated = if needs_password?(@user, user_params)
                             @user.update(user_params)
                           else
                             @user.update_without_password(user_params)
                           end
    respond_to do |format|
      if successfully_updated
        if active_was != @user.active
          @user.professional.update_attribute(:active, @user.active)
        end
        
        format.html { redirect_to users_url, notice: "#{User.model_name.human} #{I18n.t('default_messages.updated')}" }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: "#{User.model_name.human} #{I18n.t('default_messages.destroyed')}" }
      format.json { head :no_content }
    end
  end

  def edit_profile
    @user = current_user
  end

  def update_profile
    if current_user.update(user_params)
      redirect_to root_url, notice: 'Perfil atualizado com sucesso'
    else
      respond_to do |format|
        format.html { redirect_to meu_perfil_users_path, alert: 'Perfil não atualizado' }
      end
    end
  end

  private

  def set_user
    @user = User.find params[:id]
  end

  def needs_password?(user, params)
    params[:password].present?
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.require(:user).permit(:active, :name, :username, :email, :password, :password_confirmation, role_ids: [])
  end
end
