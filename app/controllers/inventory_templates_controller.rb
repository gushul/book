# encoding: utf-8
class InventoryTemplatesController < ApplicationController
  before_filter :authenticate_owner!#, 
                #except: [:index, :show]
  before_filter :check_who_editing,  
                except: [:index, :show, :new, :create, :my]
   
  # GET /inventory_templates
  def index
    # @inventory_templates = InventoryTemplate.order("id desc").page(params[:page])
    itg_all = current_owner.restaurant.inventory_template_groups
    @inventory_templates = itg_all.map do |itg|
      itg.inventory_templates 
    end
    @inventory_templates.flatten!
    @inventory_templates = Kaminari.paginate_array(@inventory_templates).page(params[:page])
  end

  def my  
    @inventory_templates = []
    current_owner.restaurant.inventory_template_groups.each do |itg|
      itg.inventory_templates.each do |it|
        @inventory_templates << it
      end
    end 

    @reservations = current_owner.restaurant.reservations

    # @reservations_by_date = @reservations.group_by(&:date)
    @date = params[:date] ? Date.parse(params[:date]) : Date.today

    # DateTime.parse('2000-01-01 11:00:00 UTC').to_time
    # @selectable_time = [["2000-01-01 00:00:00 UTC","00:00"], ["2000-01-01 00:15:00 UTC", "00:15"] ]

    @quantity = []
    4.times {|i| @quantity[i] = []}
    # current_owner.restaurant.inventory_templates.each do |it|
    #   m = it.start_time.strftime("%M").to_i
    #   m == 0 ? 0 : m = m/15
    #   h = it.start_time.strftime("%H").to_i
    #   @quantity[m][h] = it.quantity_available
    # end
    current_owner.restaurant.inventories.each do |inv|
      if inv.date == @date
        m1 = inv.start_time.strftime("%M").to_i
        m1 == 0 ? 0 : m1 = m1/15
        m2 = inv.end_time.strftime("%M").to_i
        m2 == 0 ? 0 : m2 = m2/15
        h1 = inv.start_time.strftime("%H").to_i
        h2 = inv.end_time.strftime("%H").to_i
        if h1 == h2 and (m2 - m1) > 0
          (m2 - m1).times {|t| @quantity[m1+t][h1] = inv.quantity_available }
        elsif h1 != h2
          (h2 - h1 + 1).times do |th| 
            unless th == h2 - h1
              4.times {|tm| @quantity[m1 + tm][h1 + th] = inv.quantity_available }
            else
              (m2 - m1).times {|tm| @quantity[m1 + tm][h1 + th] = inv.quantity_available }
            end
          end
        end
      end
    end

  end
  
  # GET /inventory_templates/1
  # GET /inventory_templates/1.json
  def show
    @inventory_template = InventoryTemplate.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @inventory_template }
    end
  end

  # GET /inventory_templates/new
  # GET /inventory_templates/new.json
  def new
    @inventory_template = InventoryTemplate.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @inventory_template }
    end
  end

  # GET /inventory_templates/1/edit
  def edit
    @inventory_template = InventoryTemplate.find(params[:id])
  end

  # POST /inventory_templates
  # POST /inventory_templates.json
  def create
    @inventory_template = InventoryTemplate.new(params[:inventory_template])
    # @inventory_template.restaurant = current_owner.restaurant

    @intervals = []
    24.times do |h| 
      4.times do |m| 
        if h<10 and m!=0
          @intervals << "0#{h}:#{m*15}" 
        elsif h<10 and m==0
          @intervals << "0#{h}:00" 
        elsif h>=10 and m!=0
          @intervals << "#{h}:#{m*15}" 
        elsif h>=10 and m==0
          @intervals << "#{h}:0#{m*15}" 
        else
          @intervals << "#{h}:#{m*15}" 
        end
      end
    end
    @intervals << "24:00"

    @intervals.each do |interval| 
      quan = params[:inventory_template][:quantity_available]["#{@intervals.index(interval)}".to_s]
      unless interval == "24:00" or quan.to_i == 0
        
        @inventory_template = InventoryTemplate.new(inventory_template_group_id: params[:inventory_template][:inventory_template_group_id])
        # @inventory_template = InventoryTemplate.new(name: params[:inventory_template][:name])
        # @inventory_template.restaurant = current_owner.restaurant
        # @inventory_template.primary = params[:inventory_template][:primary]
        
        @inventory_template.start_time = interval
        @inventory_template.end_time = @intervals[@intervals.index(interval)+1]
        @inventory_template.quantity_available = quan

        @inventory_template.save
      end 
    end 

    redirect_to inventory_templates_path
  end

  # PUT /inventory_templates/1
  # PUT /inventory_templates/1.json
  def update
    @inventory_template = InventoryTemplate.find(params[:id])
    # @inventory_template.restaurant = current_owner.restaurant

    respond_to do |format|
      if @inventory_template.update_attributes(params[:inventory_template])
        format.html { redirect_to @inventory_template, notice: 'Inventory template was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @inventory_template.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /inventory_templates/1
  # DELETE /inventory_templates/1.json
  def destroy
    @inventory_template = InventoryTemplate.find(params[:id])
    @inventory_template.destroy

    respond_to do |format|
      format.html { redirect_to inventory_templates_url }
      format.json { head :no_content }
    end
  end 

private 

  def check_who_editing
    # @inventory_template = InventoryTemplate.find(params[:id])
    # unless @inventory_template.restaurant.owner == current_owner
    #   respond_to do |format|
    #     format.html { 
    #       redirect_to @inventory_template, 
    #       alert: "It's not yours inventory template!" }
    #     format.json { head :no_content, 
    #       status: :unprocessable_entity  }
    #   end
    # end
  end

end
