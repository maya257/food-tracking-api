require 'rails_helper'

RSpec.describe 'Authentications', type: :request do
  describe 'POST /auth/login' do
    let!(:user) { create(:user) }
    let(:headers) { valid_headers.except('Authorization') }
    let(:valid_auth) do
      {
        email: user.email,
        password: user.password
      }.to_json
    end
    let(:invalid_auth) do
      {
        email: Faker::Internet.email,
        password: Faker::Internet.password
      }.to_json
    end

    context 'when request is valid' do
      before { post '/auth/login', params: valid_auth, headers: headers }
      it 'returns an authentication token' do
        expect(json['auth_token']).not_to be_nil
      end
    end

    context 'when request is invalid' do
      before { post '/auth/login', params: invalid_auth, headers: headers }
      it 'returns a failure message' do
        expect(json['message']).to match(/Invalid credentials!/)
      end
    end
  end
end
