class ShortUrlsController < ApplicationController
  include SessionsHelper
  before_filter :require_login
  skip_before_filter  :verify_authenticity_token
  before_action :set_short_url, only: [:show, :short_visits, :destroy]

  def index
    @short_urls = ShortUrl.where(user_id: current_user.id).paginate(:page => params[:page], :per_page => 4)
  end

  def show
    @short_url = ShortUrl.find(params[:id])
  end

  def new
    @short_url = ShortUrl.new
  end

  def short_visits
    @short_visits = @short_url.short_visits
  end

  def create
    @short_url = ShortUrl.find_or_initialize_by(original_url: short_url_params[:original_url])
    @short_url[:user_id] = current_user.id
    @short_url.shorten

    respond_to do |format|
      if @short_url.save
        format.html {
          redirect_to @short_url, notice: 'Short url was successfully created.' }
        format.json { render :show, status: :created, location: @short_url }
      else
        format.html { render :new }
        format.json { render json: @short_url.errors, status: :unprocessable_entity }
      end
    end
  end

  def redirect
    short_url = ShortUrl.find_by(shorty: params[:shorty])
    if short_url
      short_url.create_short_visit
      short_url.calculate_visits_count
      redirect_to short_url.original_url
    else
      render :new
    end
  end

  def destroy
    @short_url.destroy
    respond_to do |format|
      format.html { redirect_to short_urls_url, notice: 'Short url was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_short_url
      @short_url = ShortUrl.find(params[:id])
    end

    def short_url_params
      params.require(:short_url).permit(:original_url, :shorty, :user_id, :visits_count)
    end
end
