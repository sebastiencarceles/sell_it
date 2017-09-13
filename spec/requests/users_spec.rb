require 'rails_helper'
require 'pp'

RSpec.describe 'Users API', type: :request do
  describe 'GET /users/:id' do
    before { get "/users/#{current_user.id}", headers: authentication_header }

    it { expect(response).to be_success }

    it 'is correctly serialized' do
      pp parsed_body
      expect(parsed_body['id']).to eq current_user.id
      expect(parsed_body['fullname']).to eq current_user.fullname
      expect(parsed_body['username']).to eq current_user.username
    end
  end
end
