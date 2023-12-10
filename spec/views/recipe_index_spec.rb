# spec/views/recipes/index.html.erb_spec.rb

require 'rails_helper'

RSpec.describe 'recipes/index', type: :view do
  include Devise::Test::ControllerHelpers
  include CanCan::Ability

  let(:user) { FactoryBot.create(:user) }
  let(:foods) { FactoryBot.create_list(:food, 3, user:) }
  let(:recipes) { FactoryBot.create_list(:recipe, 3, user:, foods:) }

  before do
    assign(:recipes, recipes)
    sign_in user
  end

  it 'renders the list of recipes' do
    # Stub the `can?` method to return false for all cases
    allow(view).to receive(:can?).and_return(false)

    render

    expect(rendered).to have_selector('.container')
    expect(rendered).to have_selector('.head-section')
    expect(rendered).to have_selector('.page-title', text: 'List of Recipes')
    expect(rendered).to have_link('New Recipe', href: new_recipe_path, class: 'click-me')

    expect(rendered).to have_selector('ul')

    recipes.each do |recipe|
      expect(rendered).to have_selector('.recipes_list')
      expect(rendered).to have_selector('.recipe_detail')
      expect(rendered).to have_selector('.recipe-name a', text: recipe.name)
      expect(rendered).to have_selector('.recipe-des', text: recipe.description)

      if can?(:destroy, recipe)
        expect(rendered).to have_button('Remove', type: 'submit', count: 0)
      else
        expect(rendered).not_to have_button('Remove', type: 'submit')
      end
    end
  end
end
