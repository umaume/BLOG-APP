require 'rails_helper'

RSpec.describe PostsController, type: :request do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:category) { create(:category) }
  let(:post) { create(:post, user: user, category: category) }

  describe 'GET /posts' do
    let!(:published_posts) { create_list(:post, 3, published: true) }
    let!(:draft_posts) { create_list(:post, 2, published: false) }

    it 'returns a success response' do
      get posts_path
      expect(response).to be_successful
    end

    it 'filters by search query' do
      searched_post = create(:post, title: 'Ruby on Rails', published: true)
      get posts_path, params: { search: 'Rails' }
      expect(response.body).to include(searched_post.title)
    end

    it 'filters by category' do
      category_post = create(:post, category: category, published: true)
      get posts_path, params: { category_id: category.id }
      expect(response.body).to include(category_post.title)
    end
  end

  describe 'GET #show' do
    it 'returns a success response' do
      get :show, params: { id: post.to_param }
      expect(response).to be_successful
    end

    it 'assigns the requested post' do
      get :show, params: { id: post.to_param }
      expect(assigns(:post)).to eq(post)
    end

    it 'builds a new comment' do
      get :show, params: { id: post.to_param }
      expect(assigns(:comment)).to be_a_new(Comment)
    end
  end

  describe 'GET #new' do
    context 'when user is authenticated' do
      before { sign_in user }

      it 'returns a success response' do
        get :new
        expect(response).to be_successful
      end

      it 'assigns a new post' do
        get :new
        expect(assigns(:post)).to be_a_new(Post)
      end
    end

    context 'when user is not authenticated' do
      it 'redirects to sign in' do
        get :new
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'GET #edit' do
    context 'when user owns the post' do
      before { sign_in user }

      it 'returns a success response' do
        get :edit, params: { id: post.to_param }
        expect(response).to be_successful
      end
    end

    context 'when user does not own the post' do
      before { sign_in other_user }

      it 'redirects to posts path' do
        get :edit, params: { id: post.to_param }
        expect(response).to redirect_to(posts_path)
      end
    end

    context 'when user is not authenticated' do
      it 'redirects to sign in' do
        get :edit, params: { id: post.to_param }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'POST #create' do
    let(:valid_attributes) do
      {
        title: 'Test Post',
        content: 'This is a test post content that is long enough.',
        published: true,
        category_id: category.id,
      }
    end

    let(:invalid_attributes) do
      {
        title: '',
        content: 'Short',
        published: true,
      }
    end

    context 'when user is authenticated' do
      before { sign_in user }

      context 'with valid parameters' do
        it 'creates a new Post' do
          expect {
            post :create, params: { post: valid_attributes }
          }.to change(Post, :count).by(1)
        end

        it 'redirects to the created post' do
          post :create, params: { post: valid_attributes }
          expect(response).to redirect_to(Post.last)
        end

        it 'assigns the post to the current user' do
          post :create, params: { post: valid_attributes }
          expect(Post.last.user).to eq(user)
        end
      end

      context 'with invalid parameters' do
        it 'does not create a new Post' do
          expect {
            post :create, params: { post: invalid_attributes }
          }.to_not change(Post, :count)
        end

        it 'renders the new template' do
          post :create, params: { post: invalid_attributes }
          expect(response).to render_template(:new)
        end
      end
    end

    context 'when user is not authenticated' do
      it 'redirects to sign in' do
        post :create, params: { post: valid_attributes }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'PATCH #update' do
    let(:new_attributes) do
      {
        title: 'Updated Title',
        content: 'Updated content that is long enough for validation.',
      }
    end

    context 'when user owns the post' do
      before { sign_in user }

      context 'with valid parameters' do
        it 'updates the requested post' do
          patch :update, params: { id: post.to_param, post: new_attributes }
          post.reload
          expect(post.title).to eq('Updated Title')
        end

        it 'redirects to the post' do
          patch :update, params: { id: post.to_param, post: new_attributes }
          expect(response).to redirect_to(post)
        end
      end

      context 'with invalid parameters' do
        it 'renders the edit template' do
          patch :update, params: { id: post.to_param, post: { title: '' } }
          expect(response).to render_template(:edit)
        end
      end
    end

    context 'when user does not own the post' do
      before { sign_in other_user }

      it 'redirects to posts path' do
        patch :update, params: { id: post.to_param, post: new_attributes }
        expect(response).to redirect_to(posts_path)
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'when user owns the post' do
      before { sign_in user }

      it 'destroys the requested post' do
        post_to_delete = create(:post, user: user)
        expect {
          delete :destroy, params: { id: post_to_delete.to_param }
        }.to change(Post, :count).by(-1)
      end

      it 'redirects to the posts list' do
        delete :destroy, params: { id: post.to_param }
        expect(response).to redirect_to(posts_path)
      end
    end

    context 'when user does not own the post' do
      before { sign_in other_user }

      it 'redirects to posts path' do
        delete :destroy, params: { id: post.to_param }
        expect(response).to redirect_to(posts_path)
      end

      it 'does not destroy the post' do
        expect {
          delete :destroy, params: { id: post.to_param }
        }.to_not change(Post, :count)
      end
    end
  end

  describe 'POST #like' do
    context 'when user is authenticated' do
      before { sign_in user }

      it 'creates a like' do
        expect {
          post :like, params: { id: post.to_param }
        }.to change(Like, :count).by(1)
      end

      it 'redirects back or to the post' do
        post :like, params: { id: post.to_param }
        expect(response).to have_http_status(:redirect)
      end
    end

    context 'when user is not authenticated' do
      it 'redirects to sign in' do
        post :like, params: { id: post.to_param }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'DELETE #unlike' do
    let!(:like) { create(:like, user: user, post: post) }

    context 'when user is authenticated' do
      before { sign_in user }

      it 'destroys the like' do
        expect {
          delete :unlike, params: { id: post.to_param }
        }.to change(Like, :count).by(-1)
      end
    end

    context 'when user is not authenticated' do
      it 'redirects to sign in' do
        delete :unlike, params: { id: post.to_param }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
