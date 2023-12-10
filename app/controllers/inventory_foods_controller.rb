class InventoryFoodsController < ApplicationController
  before_action :set_inventory
  before_action :set_inventory_food, only: %i[update destroy]

  def index
    @inventory_foods = @inventory.inventory_foods
  end

  def new
    @inventory_food = @inventory.inventory_foods.build
  end

  def create
    @inventory_food = @inventory.inventory_foods.build(inventory_food_params)

    if @inventory_food.save
      redirect_to inventory_inventory_foods_path(@inventory), notice: 'Inventory Food was successfully created.'
    else
      render :new
    end
  end

  def update
    if @inventory_food.update(inventory_food_params)
      redirect_to inventory_inventory_foods_path(@inventory), notice: 'Inventory Food was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @inventory_food.destroy
    redirect_to inventory_inventory_foods_path(@inventory), notice: 'Inventory Food was successfully removed.'
  end

  private

  def set_inventory
    @inventory = Inventory.find(params[:inventory_id])
  end

  def set_inventory_food
    @inventory_food = @inventory.inventory_foods.find(params[:id])
  end

  def inventory_food_params
    params.require(:inventory_food).permit(:quantity, :food_id)
  end
end
