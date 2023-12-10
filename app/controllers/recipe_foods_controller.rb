class RecipeFoodsController < ApplicationController
  before_action :find_recipe_and_food
  before_action :check_permissions, only: :create

  def index
    @foods = Food.all
  end

  def create
    @recipe_food = @recipe.recipe_foods.build(recipe_food_params)

    if @recipe_food.save
      flash[:success] = 'Food added to recipe successfully.'
      redirect_to @recipe
    else
      flash[:error] = 'Error adding food to recipe.'
      render 'new' # Assuming you have a 'new' view for the form
    end
  end

  private

  def find_recipe_and_food
    @recipe = Recipe.find(params[:recipe_id])
    @food = Food.find(params[:recipe_food][:food_id]) # Update this line
  end

  def check_permissions
    return if current_user == @recipe.user && current_user == @food.user

    flash[:error] = 'Permission denied.'
    redirect_to @recipe
  end

  def recipe_food_params
    params.require(:recipe_food).permit(:quantity, :food_id)
  end
end
