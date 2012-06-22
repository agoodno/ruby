class LoginController < ApplicationController
  
  before_filter :authorize, :except => :login
  
  layout "admin"

  def index
    @user = User.find_by_id(session[:user_id])
    @total_orders = Order.count
  end
    
  def add_user
    @user = User.new(params[:user])
    if request.post? and @user.save
      flash.now[:notice] = "User #{@user.name} created"
      @user = User.new
    end
  end

  def login
    session[:user_id] = nil
    if request.post?
      user = User.authenticate(params[:name], params[:password])
      if user
        session[:user_id] = user.id
        uri = session[:original_uri]
        session[:original_uri] = nil
        redirect_to(uri || { :action => :index } )
      else
        flash[:notice] = "Invalid user/password combination"
      end
    end
  end

  def logout
    session[:user_id] = nil
    flash[:notice] = "Logged out"
    redirect_to(:action => "login")
  end

  def delete_user
  end

  def list_users
    @all_users = User.find(:all)
  end
end
