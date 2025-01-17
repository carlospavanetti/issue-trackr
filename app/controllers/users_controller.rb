class UsersController < ApplicationController
  before_action :set_user, only: [:update]

  def show
    @user = current_user
  end

  def update
    return unless @user == current_user

    @user.phone_number = user_params[:phone_number]
    if @user.save
      respond_to { |format| format.js }
    else
      respond_to do |format|
        format.js { render 'phone_errors.js.erb' }
      end
    end
  end

  private

  def user_params
    params.require(:user).permit(:phone_number)
  end

  def set_user
    @user = User.find(params[:id])
  end
end
