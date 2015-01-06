# encoding: utf-8
# TODO: rework 
class Api::FavsController < Api::BaseController

  # GET /favs.json
  def index
    u = User.where("email = ?", params[:user][:email] ).first
    if u.nil? or !u.valid_password?(params[:user][:password])
      render json: 'ERR:Incorrect Login/Password', status: 400
    else
      @favs = u.favs
      render json: @favs
    end
  end

  # POST /favs.json
  def create
    u = User.where("email = ?", params[:user][:email] ).first
    if u.nil? or !u.valid_password?(params[:user][:password])
      render json: 'ERR:Incorrect Login/Password', status: 400
    else
      puts params[:fav]
      @fav = Fav.new()
      @fav = Fav.new(params[:fav])
      @fav.user = u
      @fav.save
      render json: @fav
    end
  end
  
   # POST /favs/delete.json
  def delete
    u = User.where("email = ?", params[:user][:email] ).first
    if u.nil? or !u.valid_password?(params[:user][:password])
      render json: 'ERR:Incorrect Login/Password', status: 400
    else
      puts params[:fav][:id]
      @fav = Fav.find(params[:fav][:id])
      if @fav.user == u then
        @fav.delete
      else
        puts "possible illegal delete"
      end
      render json: 'OK', status: 200
    end

  end

end   