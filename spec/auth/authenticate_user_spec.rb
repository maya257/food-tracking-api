require 'rails_helper'

RSpec.describe AuthenticateUser do
  let(:user) { create(:user) }
  subject(:valid_auth) { described_class.new(user.email, user.password) }
  subject(:invalid_auth) { described_class.new('user', '12345') }

  describe '#call' do
    context 'when valid credentials' do
      it 'returns an auth token' do
        token = valid_auth.call
        expect(token).not_to be_nil
      end
    end

    context 'when invalid credentials' do
      it 'raises an authentication error' do
        expect { invalid_auth.call }.to raise_error(
          ExceptionHandler::AuthenticationError,
          /Invalid credentials!/
        )
      end
    end
  end
end
