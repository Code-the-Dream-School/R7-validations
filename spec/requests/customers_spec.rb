require 'rails_helper'
require 'spec_helper'
require 'byebug'
RSpec.describe "CustomersControllers", type: :request do
  describe "get customers_path" do
    it "renders the index view" do
      FactoryBot.create_list(:customer, 10)
      get customers_path
      expect(response).to render_template(:index)
    end
  end
  describe "get customer_path" do
    it "renders the :show template" do
      customer = FactoryBot.create(:customer)
      get customer_path(id: customer.id)
      expect(response).to render_template(:show)
    end
    it "redirects to the index path if the customer id is invalid" do
      get customer_path(id: 5000) #an ID that doesn't exist
      expect(response).to redirect_to customers_path
    end
  end
  describe "get new_customer_path" do
    it "renders the :new template" do
      get new_customer_path
      expect(response).to render_template(:new)
    end
  end
  describe "get edit_customer_path" do
    it "renders the :edit template"  do
      customer = FactoryBot.create(:customer)
      get edit_customer_path(id: customer.id)
      expect(response).to render_template(:edit)
    end
  end
  describe "post customers_path with valid data" do
    it "saves a new entry and redirects to the show path for the entry" do
      customer_attributes = FactoryBot.attributes_for(:customer)
      expect { post customers_path, params: {customer: customer_attributes}
    }.to change(Customer, :count)
      expect(response).to redirect_to customer_path(id: Customer.last.id)
    end
  end
  describe "post customers_path with invalid data" do
    it "does not save a new entry or redirect" do
      customer_attributes = FactoryBot.attributes_for(:customer)
      customer_attributes.delete(:first_name)
      expect { post customers_path, params: {customer: customer_attributes}
    }.to_not change(Customer, :count)
      expect(response).to render_template(:new)
    end
  end
  describe "put customer_path with valid data" do
    customer = FactoryBot.create(:customer)
    customer_attributes = FactoryBot.attributes_for(:customer)
    before do
      put "/customers/#{customer.id}",params: {customer: customer_attributes}
    end
    it "updates an entry and redirects to the show path for the customer" do
      expect(response).to redirect_to customer_path(id: Customer.last.id)
    end
  end
  
  describe "put customer_path with invalid data" do
    
    it "does not update the customer record or redirect" do
      customer = FactoryBot.create(:customer)
      customer_attributes = FactoryBot.attributes_for(:customer)
      put "/customers/#{customer.id}",params: {customer: customer_attributes}
      expect(response).to redirect_to "/customers/#{customer.id}"
      expect(response.status).to eq 302
    end
  end
  describe "delete a customer record" do
    it 'should return status 302' do
      customer = FactoryBot.create(:customer)
      customer2 = FactoryBot.create(:customer)
      delete "/customers/#{customer.id}"
      expect(response.status).to eq 302
    end
    it "deletes a customer record" do
      customer = FactoryBot.create(:customer)
      customer2 = FactoryBot.create(:customer)
      expect do
        delete "/customers/#{customer.id}"
      #expect(Customer.all).to eq customer2
      end.to change(Customer, :count).by(-1)
    end
  end
end