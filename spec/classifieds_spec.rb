require 'rails_helper'

RSpec.describe 'Classifieds API', type: :request do
  describe 'GET /classifieds' do
    before { 
      FactoryGirl.create_list :classified, 3
      get "/classifieds" 
    }

    it 'works' do
      expect(response).to be_success
    end

    it 'returns all the entries' do
      expect(parsed_body.count).to eq Classified.all.count
    end
  end

  describe 'GET /classifieds/:id' do
    let(:classified) { FactoryGirl.create :classified }

    before { get "/classifieds/#{classified.id}" }

    it 'works' do
      expect(response).to be_success
    end

    it 'is correctly serialized' do
      expect(parsed_body['title']).to eq classified.title
      expect(parsed_body['price']).to eq classified.price
      expect(parsed_body['description']).to eq classified.description
    end
  end
end