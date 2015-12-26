class UsersController < ApplicationController
  skip_before_filter  :verify_authenticity_token

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html {
          log_in @user
          redirect_to short_urls_path, notice: 'Short url was successfully created.'
        }
        format.json {
          log_in @user
          render json: @short_urls, status: :created, location: @short_url  }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :name, :password)
  end
end
