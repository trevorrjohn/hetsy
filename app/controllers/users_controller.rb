class UsersController < ApplicationController
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
    begin
      @user = User.find(params[:id])
    rescue
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
      redirect_to @user
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
end
