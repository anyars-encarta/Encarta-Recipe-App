# spec/controllers/inventories_controller_spec.rb
require 'rails_helper'

RSpec.describe InventoriesController, type: :controller do
  let(:user) { create(:user) }
  let(:admin_user) { create(:user, admin: true) }
  let(:inventory) { create(:inventory, user:) }

  before do
    sign_in user
  end

  describe 'GET #index' do
    it 'renders the index template' do
      get :index
      expect(response).to render_template(:index)
    end

    it 'assigns all inventories to @inventories' do
      inventory # Create an inventory before the test
      get :index
      expect(assigns(:inventories)).to eq([inventory])
    end
  end

  describe 'GET #show' do
    it 'renders the show template' do
      get :show, params: { id: inventory.id }
      expect(response).to render_template(:show)
    end

    it 'assigns the requested inventory to @inventory' do
      get :show, params: { id: inventory.id }
      expect(assigns(:inventory)).to eq(inventory)
    end
  end

  describe 'GET #new' do
    it 'renders the new template' do
      get :new
      expect(response).to render_template(:new)
    end

    it 'assigns a new inventory to @inventory' do
      get :new
      expect(assigns(:inventory)).to be_a_new(Inventory)
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'creates a new inventory' do
        expect do
          post :create, params: { inventory: FactoryBot.attributes_for(:inventory), user: }
        end.to change(Inventory, :count).by(1)
      end

      it 'redirects to inventories_path' do
        post :create, params: { inventory: FactoryBot.attributes_for(:inventory), user: }
        expect(response).to redirect_to(inventories_path)
      end
    end

    context 'with invalid attributes' do
      it 'does not create a new inventory' do
        expect do
          post :create, params: { inventory: FactoryBot.attributes_for(:inventory, name: nil), user: }
        end.not_to change(Inventory, :count)
      end

      it 'renders the new template' do
        post :create, params: { inventory: FactoryBot.attributes_for(:inventory, name: nil), user: }
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'GET #edit' do
    it 'renders the edit template' do
      get :edit, params: { id: inventory.id }
      expect(response).to render_template(:edit)
    end

    it 'assigns the requested inventory to @inventory' do
      get :edit, params: { id: inventory.id }
      expect(assigns(:inventory)).to eq(inventory)
    end
  end

  describe 'PATCH #update' do
    context 'with valid attributes' do
      it 'updates the inventory' do
        patch :update, params: { id: inventory.id, inventory: { name: 'Updated Inventory' } }
        inventory.reload
        expect(inventory.name).to eq('Updated Inventory')
      end

      it 'redirects to the inventory' do
        patch :update, params: { id: inventory.id, inventory: { name: 'Updated Inventory' } }
        expect(response).to redirect_to(inventory)
      end
    end

    context 'with invalid attributes' do
      it 'does not update the inventory' do
        patch :update, params: { id: inventory.id, inventory: { name: nil } }
        inventory.reload
        expect(inventory.name).not_to be_nil
      end

      it 'renders the edit template' do
        patch :update, params: { id: inventory.id, inventory: { name: nil } }
        expect(response).to render_template(:edit)
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the inventory' do
      inventory # Create an inventory before the test
      expect do
        delete :destroy, params: { id: inventory.id }
      end.to change(Inventory, :count).by(-1)
    end

    it 'redirects to inventories_path' do
      delete :destroy, params: { id: inventory.id }
      expect(response).to redirect_to(inventories_path)
    end
  end

  describe 'User permissions' do
    let(:other_user) { create(:user) }
    let(:other_inventory) { create(:inventory, user: other_user) }

    it 'does not allow non-admin users to edit other user\'s inventory' do
      sign_in other_user
      get :edit, params: { id: other_inventory.id }
      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to eq('You do not have permission to delete this item.')
    end

    it 'allows admin users to edit other user\'s inventory' do
      sign_in admin_user
      get :edit, params: { id: other_inventory.id }
      expect(response).to render_template(:edit)
    end
  end
end
