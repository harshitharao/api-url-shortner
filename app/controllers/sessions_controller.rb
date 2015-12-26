class SessionsController < ApplicationController
  skip_before_filter  :verify_authenticity_token

  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)

    respond_to do |format|
      if user && user.authenticate(params[:session][:password])
        format.html {
          log_in user
          user.generate_api_token
          redirect_to short_urls_path
        }
        format.json {
          log_in user
          render json: @short_urls, status: :created, location: @short_url }
      else
        format.html { render :new }
        format.json { render json: :new, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    log_out
    redirect_to root_url
  end
end
