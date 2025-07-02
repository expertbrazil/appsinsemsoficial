class FinancialsController < ApplicationController
   before_action :authenticate_user!
   before_action :authorize, if: :user_signed_in?
end
