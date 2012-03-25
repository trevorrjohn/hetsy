class UsersController < ApplicationController
  # API Keys
  ETSY_KEYSTRING     = ENV['ETSY_KEYSTRING']
  ETSY_SHARED_SECRET = ENV['ETSY_SHARED_SECRET']
  TOPIC_STR = "cat_art-design%2Ccat_autos%2Ccat_eat-drink%2Ccat_men-s-fashion%2Ccat_home-garden%2Ccat_sports-fitness" #%2C == ','

  before_filter :signed_in_user, only: [:edit, :update, :show]
  before_filter :correct_user,   only: [:edit, :update, :show]
  before_filter :is_admin?,      only: [:index]

  def index
    if params[:sort_by].nil? || params[:sort_by] == "ID"
      @users = User.all
    elsif params[:sort_by] == "Name"
      @users = User.all.sort_by{ |n| n.name }
    else
      @users = User.all.sort_by{ |n| n.email }
    end
  end

  def show

    if @user = User.find(params[:id])
      unless @user.auth_token.blank?
        @listings = fill_listings(@user)
      end
    else
      redirect_to root_path
    end
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to Syphus Training"
      redirect_to 'http://hunch.com/authorize/v1/?app_id=3148074' 
    else
      flash[@user.errors]
      render "new"
    end
  end

  def edit
    begin
      @user = User.find(params[:id])
    rescue
      redirect_to root_path
    end
  end

  def update
    begin
      @user = User.find(params[:id])
      if @user.update_attributes(params[:user])
        sign_in @user
        flash[:sucess] = "User updated."
        render "show"
      else
        render "edit"
      end
    rescue
      redirect_to root_path
    end
  end

  def destroy
    begin
      User.find(params[:id]).delete
      redirect_to users_path
    rescue
      redirect_to root_path
    end
  end

  private

  def signed_in_user
    unless signed_in?
      store_location
      redirect_to signin_path, notice: "Please sign in." unless signed_in?
    end
  end

  def correct_user
    begin
      @user = User.find(params[:id])
      redirect_to root_path unless (current_user?(@user) || @user.admin?)
    rescue
      redirect_to signin_path
    end
  end

  def is_admin?
    redirect_to root_path unless current_user && current_user.admin?
  end

  def fill_listings(user)
    recommendation = get_recommendations(user.auth_token)
    get_etsy_listings(recommendation)
  end

  def get_etsy_listings(recommendations)
    # keywords = ""
    # array = []
    # while keywords.blank?
      # 2.times { array << recommendations.sample["tags"].sample } 
      # keywords = array.join("%2C").gsub(" ","+") unless array.empty?
    # end
    keywords = recommendations.sample["tags"].sample.to_s.gsub(" ", "+")
    url = "http://openapi.etsy.com/v2/listings/active?api_key=#{ENV['ETSY_KEYSTRING']}&keywords=#{keywords}&includes=MainImage"
    response = RestClient.get url
    result = JSON.parse(response)
    result["results"]
  end

  def get_recommendations(auth_token)
    url = "http://api.hunch.com/api/v1/get-recommendations/?auth_token=#{auth_token}&topic_ids=#{TOPIC_STR}&sites=hn&exclude_likes=1&limit=100"
    response = RestClient.get url
    result = JSON.parse(response)
    result["recommendations"]
  end

end
