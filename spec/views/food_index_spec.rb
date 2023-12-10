require 'rails_helper'

RSpec.describe 'Foods', type: :feature do
  let(:user) { FactoryBot.create(:user, confirmed_at: Time.current) }
  let(:other_user) { FactoryBot.create(:user, confirmed_at: Time.current) }

  before do
    sign_in user
    FactoryBot.create(:food, name: 'Sample Food 1', measurement_unit: 'kg', price: 20, quantity: 3)
    FactoryBot.create(:food, name: 'Sample Food 2', measurement_unit: 'g', price: 10, quantity: 5)
    visit foods_path
  end

  describe 'Food Index Page' do
    include Devise::Test::IntegrationHelpers

    it 'displays the list of foods' do
      expect(page).to have_content('List of Foods')
      expect(page).to have_content('Sample Food 1')
      expect(page).to have_content('kg')
      expect(page).to have_content('$20.00')
      expect(page).to have_content('3')
      expect(page).to have_content('Sample Food 2')
      expect(page).to have_content('g')
      expect(page).to have_content('$10.00')
      expect(page).to have_content('5')
    end

    it 'displays the Add Food form' do
      expect(page).to have_content('Add Food')
      expect(page).to have_field('food_name')
      expect(page).to have_field('food_measurement_unit')
      expect(page).to have_field('food_price')
      expect(page).to have_field('food_quantity')
      expect(page).to have_button('Add Food')
    end

    it 'adds a new food' do
      expect(page).to have_content('Add Food')
      click_button('Add Food')
      fill_in 'food_name', with: 'New Food'
      fill_in 'food_measurement_unit', with: 'pcs'
      fill_in 'food_price', with: '15'
      fill_in 'food_quantity', with: '10'
      click_button 'Add Food'

      expect(page).to have_content('Food was successfully created.')
      expect(page).to have_content('New Food')
      expect(page).to have_content('pcs')
      expect(page).to have_content('$15.00')
      expect(page).to have_content('10')
    end

    it 'deletes a food' do
      if page.has_link?('Delete', count: 1)
        expect(page).to have_css('a[data-method="delete"]', text: 'Delete', count: 1)
        accept_confirm("Are you sure you want to delete #{food.name} from the database?") do
          click_link('Delete', match: :first)
        end
        expect(page).to have_content('Food was successfully deleted.')
        expect(page).not_to have_content('Sample Food 1')
        expect(page).to have_content('Sample Food 2')
      end
    end
  end
end
