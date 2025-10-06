require 'rails_helper'

RSpec.describe 'User Authentication', type: :request do
  let(:user) { create(:user) }

  describe 'User Registration' do
    let(:valid_params) do
      {
        user: {
          name: 'New User',
          email: 'newuser@example.com',
          password: 'password123',
          password_confirmation: 'password123',
        },
      }
    end

    it 'allows user to sign up' do
      post user_registration_path, params: valid_params
      expect(response).to redirect_to(root_path)
    end

    it 'creates a new user' do
      expect {
        post user_registration_path, params: valid_params
      }.to change(User, :count).by(1)
    end
  end

  describe 'User Sign In' do
    let(:sign_in_params) do
      {
        user: {
          email: user.email,
          password: user.password,
        },
      }
    end

    it 'allows user to sign in with valid credentials' do
      post user_session_path, params: sign_in_params
      expect(response).to redirect_to(root_path)
    end

    it 'rejects invalid credentials' do
      invalid_params = sign_in_params.deep_dup
      invalid_params[:user][:password] = 'wrongpassword'

      post user_session_path, params: invalid_params
      expect(response).to render_template(:new)
    end
  end

  describe 'Authentication Required Routes' do
    it 'redirects unauthenticated users to sign in for new post' do
      get new_post_path
      expect(response).to redirect_to(new_user_session_path)
    end

    it 'allows authenticated users to access new post page' do
      sign_in user
      get new_post_path
      expect(response).to have_http_status(:success)
    end
  end

  describe 'User Profile' do
    it 'displays user profile page' do
      get user_path(user)
      expect(response).to have_http_status(:success)
      expect(response.body).to include(user.display_name)
    end

    it 'allows user to edit their own profile' do
      sign_in user
      get edit_user_path(user)
      expect(response).to have_http_status(:success)
    end

    it 'prevents user from editing another user\'s profile' do
      other_user = create(:user)
      sign_in user
      get edit_user_path(other_user)
      expect(response).to redirect_to(root_path)
    end
  end
end
