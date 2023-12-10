class FoodsController < ApplicationController
  before_action :authenticate_user!

  def index
    @is_active = true
    if params[:id] == 'missing_foods'
      missing_foods
      render :missing_foods
    else
      @foods = Food.all
    end
  end

  def show
    if params[:id] == 'missing_foods'
      missing_foods
      render :missing_foods
    else
      @food = Food.find(params[:id])
    end
  end

  def new
    @food = Food.new
  end

  def missing_foods
    recipes_with_foods = current_user.recipes.includes(:foods)
    food_ids_from_recipes = recipes_with_foods.flat_map { |recipe| recipe.foods.pluck(:id) }
    inventory_foods = current_user.inventories.flat_map { |inventory| inventory.inventory_foods.includes(:food) }
    food_ids_from_inventory = inventory_foods.flat_map { |inv_food| inv_food.food.id }
    missing_foods_from_recipes = current_user.foods.where.not(id: food_ids_from_recipes)
    missing_foods_from_inventory = current_user.foods.where.not(id: food_ids_from_inventory)
    # Ensure that the variables are not nil before using map
    @missing_foods_from_recipes = missing_foods_from_recipes || []
    @missing_foods_from_inventory = missing_foods_from_inventory || []

    @missing_foods = @missing_foods_from_recipes + @missing_foods_from_inventory
    @total_items = @missing_foods.count
    @total_price = @missing_foods.sum(&:price)
  end

  def create
    @food = current_user.foods.new(food_params)
    if @food.save
      redirect_to foods_path, notice: 'Food was successfully created.'
    else
      render :new
    end
  end

  def destroy
    @food = Food.find(params[:id])
    if current_user == @food.user
      @food.destroy
      redirect_to foods_path, notice: 'Food was successfully deleted.'
    else
      redirect_to foods_path, alert: 'You are not authorized to delete this food.'
    end
  end

  private

  def food_params
    params.require(:food).permit(:name, :measurement_unit, :price, :quantity)
  end
end
