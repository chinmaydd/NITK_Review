class UsersController < ApplicationController
    
  before_action :confirm_logged_in, except: [:attempt_login, :home, :new, :create]

  def new
    if session[:user_id]!=nil
      redirect_to(action: 'dashboard', controller: 'movies')
      return 
    end

    @user = User.new
  end

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
    @current_user = User.find(session[:user_id])
    @reviews = Review.all
    @count = 0
    @reviews.each do |r|
      if r.user == @user
        @count+=1
      end
    end
  end

  def create
    if session[:user_id]!=nil
      redirect_to(action: 'dashboard', controller: 'movies')
      return 
    end

    @user = User.new(user_param)
    if @user.save
      session[:user_id] = @user.id
      session[:username] = @user.username
      redirect_to(controller: 'movies', action: 'dashboard')#change to posts
    else
      render("new")
    end
  end

  def attempt_login
    puts params[:user][:username]+params[:user][:password]
    if params[:user][:username].present? && params[:user][:password].present?
      found_user = User.where(:username => params[:user][:username]).first
      if found_user
        if found_user.authenticate(params[:user][:password])
         authorized_user = found_user
        end
      end
    end
    if authorized_user
      session[:user_id] = authorized_user.id
      session[:username] = authorized_user.username
      flash[:notice] = "You are now logged in."
      redirect_to(controller: 'movies', action: 'dashboard')
    else
      flash[:notice] = "Invalid username/password combination."
      redirect_to(action: 'home')
    end
  end

  def logout
    session[:user_id] = nil
    session[:username] = nil
    flash[:notice] = "You are now logged out"
    render('home')
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_param)
      flash[:notice] = "Data Updated Succesfully"
      redirect_to(action: 'show' , id: @user.id)
    else
      render('edit')
    end
  end

  def destroy
    @user = User.find(params[:id])
    @current_user = User.find(session[:user_id])
    if @current_user.admin?
      @user.destroy
      redirect_to(action: 'list', controller: 'movies')
    else
      @reviews = Review.all
      @reviews.each do |rev|
        if rev.user.username==@user.username
          rev.destroy
        end
      end
      session[:user_id] = nil
      session[:username] = nil
      @user.destroy
      redirect_to(action: 'home')
    end
  end

  def home  
    if session[:user_id]!=nil
      redirect_to(controller: 'movies', action: 'dashboard')
    end
  end

  private

  def user_param
    params.require(:user).permit(:first_name, :last_name, :email, :username, :password)
  end
end
