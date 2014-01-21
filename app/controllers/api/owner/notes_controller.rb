# encoding: utf-8
class Api::Owner::NotesController < ApplicationController
  skip_before_filter  :verify_authenticity_token

  before_filter :check_owner_auth_params
  
  # POST /notes.json
  def index
    @notes = @owner.restaurant.notes
    @notes_json = []
    @notes.each do |r|
      r = r.as_json
      %w{created_at updated_at restaurant_id}.each {|k| r.delete(k)}
      @notes_json << r
    end
    
    respond_to do |format|
      unless @notes.blank?
        format.json { render json: @notes_json, status: 200 }
      else
        format.json { render json: "No notes yet", status: 200 }
      end
    end
  end

  # POST /notes/create
  def create
    @note = Note.new(params[:note])
    @note.restaurant_id = @owner.restaurant.id

    respond_to do |format|
      if @note.save 
        format.json { render json: @note, status: 200 }
      else
        format.json { render json: @note.errors, 
                           status: :unprocessable_entity }
      end
    end
    
  end

  # POST /notes/update
  def update
    @note = @owner.restaurant.notes.find(params[:note][:id])

    respond_to do |format|
      if @note.update_attributes(params[:note])
        format.json { render json: @note, status: 200  }
      else
        format.json { render json: @note.errors, status: :unprocessable_entity }
      end
    end
  end

  # POST /notes/delete
  def delete
    @note = @owner.restaurant.notes.where(id: params[:note][:id]).first

    respond_to do |format|
      if @note.present? && @note.destroy
        format.json { render json: "Successfully", status: 200  }
      else
        format.json { render json: "ERR:Check parameters", 
                           status: :unprocessable_entity }
      end
    end
  end

private

  def check_owner_auth_params
    error = false
    if params[:owner].blank? or
          %w{email password}.map {|el| params[:owner].has_key?(el) }.include?(false) or
          params[:owner].values.any?(&:blank?)
      error   = true
      message = "Provide CORRECT login/pass parameters for this action"
      status  = 403
    elsif params[:owner].length > 2
      error   = true
      message = "Provide ONLY needed parameters for this action"
      status  = 400
    else 
      # will be used in create and update
      @owner = Owner.where(:email => params[:owner][:email] ).first
      if @owner.nil? or !@owner.valid_password?(params[:owner][:password])
        error   = true
        message = "Incorect login/pass"
        status  = 403
      end
    end

    if error
      render json: message, status: status 
    end
  end


end