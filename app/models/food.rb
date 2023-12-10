# app/models/food.rb

class Food < ApplicationRecord
  belongs_to :user

  has_many :inventory_foods, dependent: :destroy
  validates :user_id, presence: true

  has_many :inventories, through: :inventory_foods
  has_many :recipe_foods
  has_many :recipes, through: :recipe_foods

  after_create :create_recipe_foods_entry

  private

  def create_recipe_foods_entry
    Recipe.all.each do |recipe|
      recipe.recipe_foods.create(food: self, quantity: 0)
    end
  end
end
