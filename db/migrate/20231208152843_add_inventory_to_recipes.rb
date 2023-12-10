class AddInventoryToRecipes < ActiveRecord::Migration[7.1]
  def change
    add_reference :recipes, :inventory, null: true, foreign_key: true
  end
end
