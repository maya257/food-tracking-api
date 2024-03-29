require 'rails_helper'

RSpec.describe 'Users', type: :request do
  let(:user) { build(:user) }
  let(:headers) { valid_headers.except('Authorization') }
  let(:valid_attr) { attributes_for(:user, password_confirmation: user.password) }

  describe 'POST /signup' do
    context 'when valid request' do
      before { post '/signup', params: valid_attr.to_json, headers: headers }

      it 'creates a new user' do
        expect(response).to have_http_status(201)
      end

      it 'returns success message' do
        expect(json['message']).to match(/Registration successful!/)
      end

      it 'returns an authentication token' do
        expect(json['auth_token']).not_to be_nil
      end
    end

    context 'when invalid request' do
      before { post '/signup', params: {}, headers: headers }

      it 'does not create a new user' do
        expect(response).to have_http_status(422)
      end

      it 'returns failure message' do
        expect(json['message'])
          .to match(
            /Validation failed: Password can't be blank, Email can't be blank, Password digest can't be blank/
          )
      end

      it 'does not return an authentication token' do
        expect(json['auth_token']).to be_nil
      end
    end
  end
end
