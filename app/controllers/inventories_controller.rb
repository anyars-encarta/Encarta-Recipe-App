class InventoriesController < ApplicationController
  before_action :set_inventory, only: %i[edit update destroy]

  def index
    @inventories = Inventory.all
  end

  def show
    @inventory = Inventory.find(params[:id])
  end

  def new
    @inventory = Inventory.new
  end

  def create
    @inventory = Inventory.new(inventory_params)
    @inventory.user = current_user
    if @inventory.save
      redirect_to inventories_path(current_user), notice: 'Inventory was successfully created.'
    else
      render :new
    end
  end

  def edit
    #  logic for edit
  end

  def update
    if @inventory.update(inventory_params)
      redirect_to @inventory, notice: 'Inventory was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @inventory.destroy
    redirect_to inventories_url, notice: 'Inventory was successfully destroyed.'
  end

  private

  def validate_user
    return if @inventory && (current_user.id == @inventory.users_id || current_user.admin?)

    flash[:alert] = 'You do not have permission to delete this item.'
    redirect_back fallback_location: root_path
  end

  def set_inventory
    @inventory = Inventory.find(params[:id])
  end

  def inventory_params
    params.require(:inventory).permit(:name, :description, :users_id)
  end
end
