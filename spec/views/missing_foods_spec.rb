require 'rails_helper'

RSpec.describe 'foods/missing_foods.html.erb', type: :view do
  before do
    assign(:total_items, 10)
    assign(:total_price, 100)

    food1 = Food.new(name: 'Food 1', quantity: 2, price: 10)
    food2 = Food.new(name: 'Food 2', quantity: 3, price: 15)
    assign(:missing_foods, [food1, food2])

    render
  end

  it 'displays the total number of food items to buy' do
    expect(rendered).to have_text('Amount of food items to buy: 10')
  end

  it 'displays the total value of food needed' do
    expect(rendered).to have_text('Total value of food needed: $100.00')
  end

  it 'displays the table with missing foods' do
    expect(rendered).to have_selector('table.mf-table')
    expect(rendered).to have_selector('th', text: 'Name')
    expect(rendered).to have_selector('th', text: 'Quantity')
    expect(rendered).to have_selector('th', text: 'Price')
    expect(rendered).to have_selector('tr', count: 3)
    expect(rendered).to have_selector('td', text: 'Food 1')
    expect(rendered).to have_selector('td', text: '2')
    expect(rendered).to have_selector('td', text: '$10.00')
    expect(rendered).to have_selector('td', text: 'Food 2')
    expect(rendered).to have_selector('td', text: '3')
    expect(rendered).to have_selector('td', text: '$15.00')
  end
end
