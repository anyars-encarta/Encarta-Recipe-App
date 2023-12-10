class GeneralShoppingListController < ApplicationController
  def index
    @all_recipes = Recipe.all
    @recipes = current_user.recipes.includes(:foods)
    @general_foods = current_user.foods
  end
end
