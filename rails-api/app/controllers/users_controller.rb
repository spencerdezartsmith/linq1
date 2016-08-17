class UsersController < ApplicationController
  def index
    headers['Access-Control-Allow-Origin'] = '*'
    p "hello world"
    @users = User.all
    render json: @users
  end

  def create
    @user = User.create(name: params[:name])
    redirect_to action: "index"
  end
end
