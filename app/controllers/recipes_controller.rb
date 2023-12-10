class RecipesController < ApplicationController
  before_action :authenticate_user!, only: %i[new create]

  def index
    @public_recipes = Recipe.where(public: true).includes(recipe_foods: :food)

    if @public_recipes.present?
      @total_food_items = @public_recipes.sum { |recipe| recipe.recipe_foods.sum(:quantity) } || 0
      @total_price = @public_recipes.sum { |recipe| recipe.recipe_foods.sum { |rf| rf.quantity * rf.food.price } } || 0
    else
      @total_food_items = 0
      @total_price = 0
    end

    # Debug output
    puts "Total Food Items: #{@total_food_items}"
    puts "Total Price: #{@total_price}"
  end

  def new
    @recipe = Recipe.new
  end

  def create
    @recipe = current_user.recipes.build(recipe_params)

    if @recipe.save
      redirect_to recipes_path, notice: 'Recipe was successfully created.'
    else
      render :new
    end
  end

  def destroy
    @recipe = Recipe.find(params[:id])
    authorize! :destroy, @recipe
    @recipe.destroy
    redirect_to recipes_path, notice: 'Recipe was successfully deleted.'
  end

  def show
    @recipe = Recipe.includes(:foods).find(params[:id])
    @foods = @recipe.foods
    @inventories = Inventory.all
  end

  def associate_inventory
    @recipe = Recipe.find(params[:id])
    inventory_id = params[:inventory_id]

    if inventory_id.present?
      inventory = Inventory.find(inventory_id)
      @recipe.update(inventory:)
      redirect_to inventory_path(inventory), notice: 'Inventory generated successfully!'
    else
      redirect_to @recipe, alert: 'Please select an inventory.'
    end
  end

  def public_list
    @public_recipes = Recipe.includes(:foods).where(public: true).order(created_at: :desc)

    # Debug output
    puts "Debug - Public Recipes: #{@public_recipes.inspect}"

    if @public_recipes.present?
      @total_food_items = @public_recipes.sum { |recipe| recipe.recipe_foods.sum(:quantity) } || 0
      @total_price = @public_recipes.sum { |recipe| recipe.recipe_foods.sum { |rf| rf.quantity * rf.food.price } } || 0
    else
      @total_food_items = 0
      @total_price = 0
    end
  end

  private

  def recipe_params
    params.require(:recipe).permit(:name, :preparation_time, :cooking_time, :public, :description)
  end
end
