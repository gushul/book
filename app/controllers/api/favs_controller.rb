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
      @fav = Fav.find_by_id(params[:fav][:id])
      if @fav.nil? then
        puts "no such fav"
        render json: 'ERR:no such fav', status: 400
      elsif @fav.user == u then
        @fav.delete
        render json: 'OK', status: 200
      else
        puts "possible illegal delete"
        render json: 'ERR:illegal delete', status: 400
      end
    end

  end

end   