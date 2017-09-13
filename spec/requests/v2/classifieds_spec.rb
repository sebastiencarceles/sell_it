require 'rails_helper'
require 'pp'

RSpec.describe 'Classifieds API', type: :request do
  let(:classified) { FactoryGirl.create :classified, user: current_user }

  describe 'GET /classifieds' do
    context 'when everything goes well' do
      let(:page) { 3 }
      let(:per_page) { 5 }

      before {
        FactoryGirl.create_list :classified, 18
        get "/v2/classifieds", params: { page: page, per_page: per_page }
      }

      it { expect(response).to be_success }

      it 'returns paginated results' do
        expect(parsed_body.map { |classified| classified['id'] }).to eq Classified.all.limit(per_page).offset((page - 1) * per_page).pluck(:id)
      end
    end

    it 'returns a bad request when parameters are missing' do
      get '/v2/classifieds'
      expect(response).to have_http_status :bad_request
      expect(parsed_body.keys).to include 'error'
      expect(parsed_body['error']).to eq 'missing parameters'
    end
  end

  describe 'GET /classifieds/:id' do
    context 'when everything goes well' do
      before { get "/v2/classifieds/#{classified.id}" }

      it { expect(response).to be_success }

      it 'is correctly serialized' do
        expect(parsed_body).to match({
          id: classified.id,
          title: classified.title,
          price: classified.price,
          description: classified.description,
          user: {
            id: classified.user.id,
            fullname: classified.user.fullname
          }.stringify_keys
        }.stringify_keys)
      end
    end

    it 'returns not found when the resource can not be found' do
      get '/v2/classifieds/toto'
      expect(response).to have_http_status :not_found
    end
  end

  describe 'POST /classifieds' do
    context 'when unauthenticated' do
      it 'returns unauthorized' do
        post '/v2/classifieds'
        expect(response).to have_http_status :unauthorized
      end
    end

    context 'when authenticated' do
      let(:params) {
         { classified: { title: 'title', price: 62, description: 'description' } }
      }

      it 'works' do
        post '/v2/classifieds', params: params, headers: authentication_header
        expect(response).to have_http_status :created
      end

      it 'creates a new classified' do
        expect {
          post '/v2/classifieds', params: params, headers: authentication_header
        }.to change {
          current_user.classifieds.count
        }.by 1
      end

      it 'has correct fields values for the created classified' do
        post '/v2/classifieds', params: params, headers: authentication_header
        created_classified = current_user.classifieds.last
        expect(created_classified.title).to eq 'title'
        expect(created_classified.price).to eq 62
        expect(created_classified.description).to eq 'description'
      end

      it 'returns a bad request when a parameter is missing' do
        params[:classified].delete(:price)
        post '/v2/classifieds', params: params, headers: authentication_header
        expect(response).to have_http_status :bad_request
      end

      it 'returns a bad request when a parameter is malformed' do
        params[:classified][:price] = 'trululu'
        post '/v2/classifieds', params: params, headers: authentication_header
        expect(response).to have_http_status :bad_request
      end
    end
  end

  describe 'PATCH /classifieds/:id' do
    context 'when unauthenticated' do
      it 'returns unauthorized' do
        patch "/v2/classifieds/#{classified.id}"
        expect(response).to have_http_status :unauthorized
      end
    end

    context 'when authenticated' do
      let(:params) {
         { classified: { title: 'A better title', price: 42 } }
      }

      context 'when everything goes well' do
        before { patch "/v2/classifieds/#{classified.id}", params: params, headers: authentication_header }

        it { expect(response).to be_success }

        it 'modifies the given fields of the resource' do
          modified_classified = Classified.find(classified.id)
          expect(modified_classified.title).to eq 'A better title'
          expect(modified_classified.price).to eq 42
        end
      end

      it 'returns a not found when the resource can not be found' do
        patch '/v2/classifieds/toto', params: params, headers: authentication_header
        expect(response).to have_http_status :not_found
      end

      it 'returns a bad request when a parameter is malformed' do
        params[:classified][:price] = 'trululu'
        patch "/v2/classifieds/#{classified.id}", params: params, headers: authentication_header
        expect(response).to have_http_status :bad_request
      end

      it 'returns a forbidden when the requester is not the owner of the resource' do
        another_classified = FactoryGirl.create :classified
        patch "/v2/classifieds/#{another_classified.id}", params: params, headers: authentication_header
        expect(response).to have_http_status :forbidden
      end
    end
  end

  describe 'DELETE /classifieds/:id' do
    context 'when unauthenticated' do
      it 'returns unauthorized' do
        delete "/v2/classifieds/#{classified.id}"
        expect(response).to have_http_status :unauthorized
      end
    end

    context 'when authenticated' do
      context 'when everything goes well' do
        before { delete "/v2/classifieds/#{classified.id}", headers: authentication_header }

        it { expect(response).to have_http_status :no_content }

        it 'deletes the classified' do
          expect(Classified.find_by(id: classified.id)).to eq nil
        end
      end

      it 'returns a not found when the resource can not be found' do
        delete '/v2/classifieds/toto', headers: authentication_header
        expect(response).to have_http_status :not_found
      end

      it 'returns a forbidden when the requester is not the owner of the resource' do
        another_classified = FactoryGirl.create :classified
        delete "/v2/classifieds/#{another_classified.id}", headers: authentication_header
        expect(response).to have_http_status :forbidden
      end
    end
  end
end
