class UsersController < ApplicationController
    
  before_action :confirm_logged_in, :except => [:attempt_login, :home, :new, :create] 

  def new
    @user = User.new
  end

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(user_param)
    if @user.save
      redirect_to(action: 'index')#change to posts
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
      redirect_to(action: 'index')
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

  private

  def user_param
    params.require(:user).permit(:first_name, :last_name, :email, :username, :password)
  end
end
