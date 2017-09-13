require 'rails_helper'
require 'pp'

RSpec.describe 'Classifieds API', type: :request do
  let(:classified) { FactoryGirl.create :classified, user: current_user }

  describe 'GET /classifieds' do
    before {
      FactoryGirl.create_list :classified, 3
      get "/classifieds"
    }

    it { expect(response).to be_success }

    it 'returns all the entries' do
      expect(parsed_body.count).to eq Classified.all.count
    end
  end

  describe 'GET /classifieds/:id' do
    context 'when everything goes well' do
      before { get "/classifieds/#{classified.id}" }

      it { expect(response).to be_success }

      it 'is correctly serialized' do
        pp parsed_body
        expect(parsed_body['title']).to eq classified.title
        expect(parsed_body['price']).to eq classified.price
        expect(parsed_body['description']).to eq classified.description
      end
    end

    it 'returns not found when the resource can not be found' do
      get '/classifieds/toto'
      expect(response).to have_http_status :not_found
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
      let(:params) {
         { classified: { title: 'title', price: 62, description: 'description' } }
      }

      it 'works' do
        post '/classifieds', params: params, headers: authentication_header
        expect(response).to have_http_status :created
      end

      it 'creates a new classified' do
        expect {
          post '/classifieds', params: params, headers: authentication_header
        }.to change {
          current_user.classifieds.count
        }.by 1
      end

      it 'has correct fields values for the created classified' do
        post '/classifieds', params: params, headers: authentication_header
        created_classified = current_user.classifieds.last
        expect(created_classified.title).to eq 'title'
        expect(created_classified.price).to eq 62
        expect(created_classified.description).to eq 'description'
      end

      it 'returns a bad request when a parameter is missing' do
        params[:classified].delete(:price)
        post '/classifieds', params: params, headers: authentication_header
        expect(response).to have_http_status :bad_request
      end

      it 'returns a bad request when a parameter is malformed' do
        params[:classified][:price] = 'trululu'
        post '/classifieds', params: params, headers: authentication_header
        expect(response).to have_http_status :bad_request
      end
    end
  end

  describe 'PATCH /classifieds/:id' do
    context 'when unauthenticated' do
      it 'returns unauthorized' do
        patch "/classifieds/#{classified.id}"
        expect(response).to have_http_status :unauthorized
      end
    end

    context 'when authenticated' do
      let(:params) {
         { classified: { title: 'A better title', price: 42 } }
      }

      context 'when everything goes well' do
        before { patch "/classifieds/#{classified.id}", params: params, headers: authentication_header }

        it { expect(response).to be_success }

        it 'modifies the given fields of the resource' do
          modified_classified = Classified.find(classified.id)
          expect(modified_classified.title).to eq 'A better title'
          expect(modified_classified.price).to eq 42
        end
      end

      it 'returns a not found when the resource can not be found' do
        patch '/classifieds/toto', params: params, headers: authentication_header
        expect(response).to have_http_status :not_found
      end

      it 'returns a bad request when a parameter is malformed' do
        params[:classified][:price] = 'trululu'
        patch "/classifieds/#{classified.id}", params: params, headers: authentication_header
        expect(response).to have_http_status :bad_request
      end

      it 'returns a forbidden when the requester is not the owner of the resource' do
        another_classified = FactoryGirl.create :classified
        patch "/classifieds/#{another_classified.id}", params: params, headers: authentication_header
        expect(response).to have_http_status :forbidden
      end
    end
  end

  describe 'DELETE /classifieds/:id' do
    context 'when unauthenticated' do
      it 'returns unauthorized' do
        delete "/classifieds/#{classified.id}"
        expect(response).to have_http_status :unauthorized
      end
    end

    context 'when authenticated' do
      context 'when everything goes well' do
        before { delete "/classifieds/#{classified.id}", headers: authentication_header }

        it { expect(response).to have_http_status :no_content }

        it 'deletes the classified' do
          expect(Classified.find_by(id: classified.id)).to eq nil
        end
      end

      it 'returns a not found when the resource can not be found' do
        delete '/classifieds/toto', headers: authentication_header
        expect(response).to have_http_status :not_found
      end

      it 'returns a forbidden when the requester is not the owner of the resource' do
        another_classified = FactoryGirl.create :classified
        delete "/classifieds/#{another_classified.id}", headers: authentication_header
        expect(response).to have_http_status :forbidden
      end
    end
  end
end
