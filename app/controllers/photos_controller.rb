# encoding: utf-8
class PhotosController < ApplicationController    

  def index
    @photos = Photo.all
  end

  def show
    @photo = Photo.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @photo }
    end
  end

  def new
    @photo = Photo.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @photo }
    end
  end

  def create
    @photo = Photo.new(params[:photo])

    respond_to do |format|
      if @photo.save
        format.html { redirect_to @photo, notice: 'photo was successfully created.' }
        format.json { render json: @photo, status: :created, location: @photo }
      else
        format.html { render action: "new" }
        format.json { render json: @photo.errors, status: :unprocessable_entity }
      end
    end
  end



  # def destroy    
  #   authorize! params[:action].to_sym, @photo

  #   @photo.destroy
    
  #   flash[:notice] = 'Фотография удалена'
  #   redirect_to company_photo_album_path(current_company, @photo_album)
  # end
  
  #  def set_as_cover    
  #   render :json => {:ok => @photo.cover!}
  # end

  # def mass_destroy
  #   @photos = Photo.where(:id => params[:ids])
    
  #   render_not_found and return if @photos.blank?
    
  #   @photos.each do |photo|
  #     authorize! params[:action].to_sym, photo
  #     photo.destroy
  #   end

  #   render :json => {:ok => true}
  # end

  # def mass_move
  #   @to_photo_album = current_company.photo_albums.find params[:to_photo_album_id]

  #   current_company.photos.where(:id => params[:ids]).each do |photo|
  #     photo.update_attribute :photo_album_id, @to_photo_album.id
  #   end

  #   render :json => {:ok => true}
  # end
  
  # private

  # def set_album
      
  #   @photo_album = if params[:photo_album_id].to_s.match(/\A\d*\z/)
  #       current_company.photo_albums.find params[:photo_album_id]
  #   else        
  #       current_company.photo_albums.find_by_seo_slug! params[:photo_album_id]
  #   end
  # end
  
  # def set_photo
  #   @photo = current_company.photos.find params[:id]
  #   authorize! params[:action].to_sym, @photo
  # end
end
