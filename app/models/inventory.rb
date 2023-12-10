class Inventory < ApplicationRecord
  belongs_to :user, foreign_key: 'users_id'
  has_many :inventory_foods, foreign_key: 'inventory_id'
  has_many :recipes, foreign_key: 'inventory_id'

  has_many :inventory_foods
  has_many :inventories, through: :inventory_foods

  def total_quantity
    inventory_foods.sum(:quantity)
  end

  def total_price
    inventory_foods.sum { |inventory_food| inventory_food.food.price * inventory_food.quantity }
  end
end
