class UsersController < ApplicationController
    def new
    @user = User.new
  end

  def index
    @users = User.all
  end
  

  def create
    @user = User.new(user_param)
    if @user.save
      redirect_to(action: 'index', controller: 'users')##change to posts
    else
      render("new")
    end
  end

  def edit
    @user=User.find(params[:id])
  end

  def update
    @user=User.find(params[:id])
    if @user.update_attributes(user_param)
      redirect_to(action: 'new', controller: 'users')##change to posts
    else
      render('edit')
    end
  end

  private

  def user_param
    params.require(:user).permit(:first_name, :last_name, :email, :username, :password)
  end
end
