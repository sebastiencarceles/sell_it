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

  describe 'POST /classifieds' do
    context 'when unauthenticated' do
      it 'returns unauthorized' do
        post '/classifieds'
        expect(response).to have_http_status :unauthorized
      end
    end

    context 'when authenticated' do
      it 'works' do
        post '/classifieds', params: {title: 'title', price: 62, description: 'description'}, headers: authentication_header
        expect(response).to have_http_status :created
      end

      it 'creates a new classified' do
        expect {
          post '/classifieds', params: {title: 'title', price: 62, description: 'description'}, headers: authentication_header
        }.to change {
          current_user.classifieds.count
        }.by 1
      end

      it 'has correct fields values for the created classified' do
        post '/classifieds', params: {title: 'title', price: 62, description: 'description'}, headers: authentication_header
        created_classified = current_user.classifieds.last
        expect(created_classified.title).to eq 'title'
        expect(created_classified.price).to eq 62
        expect(created_classified.description).to eq 'description'
      end

      it 'returns a bad request when a parameter is missing' do
        post '/classifieds', params: {title: 'title', price: 62}, headers: authentication_header
        expect(response).to have_http_status :bad_request
      end

      it 'returns a bad request when a parameter is malformed' do
        post '/classifieds', params: {title: 'title', price: 'trululu', description: 'description'}, headers: authentication_header
        expect(response).to have_http_status :bad_request
      end

      it 'returns a bad request when there is an extra parameter' do
        post '/classifieds', params: {title: 'title', price: 'trululu', description: 'description', onemore: 'param'}, headers: authentication_header
        expect(response).to have_http_status :bad_request
      end
    end
  end
end
