require 'rails_helper'

RSpec.describe 'Posts', type: :request do
  let(:user) { create(:user) }
  let!(:published_posts) { create_list(:post, 3, published: true) }

  describe 'GET /posts' do
    it 'returns a successful response' do
      get posts_path
      expect(response).to have_http_status(:success)
    end

    it 'displays published posts' do
      get posts_path
      published_posts.each do |post|
        expect(response.body).to include(post.title)
      end
    end

    it 'does not display draft posts' do
      draft_post = create(:post, published: false)
      get posts_path
      expect(response.body).not_to include(draft_post.title)
    end
  end

  describe 'GET /posts/:id' do
    let(:post) { published_posts.first }

    it 'returns a successful response' do
      get post_path(post)
      expect(response).to have_http_status(:success)
    end

    it 'displays the post content' do
      get post_path(post)
      expect(response.body).to include(post.title)
      expect(response.body).to include(post.content)
    end
  end

  describe 'POST /posts' do
    let(:valid_params) do
      {
        post: {
          title: 'Test Post',
          content: 'This is a test post with enough content to pass validation.',
          published: true,
        },
      }
    end

    context 'when user is signed in' do
      before { sign_in user }

      it 'creates a new post' do
        expect {
          post posts_path, params: valid_params
        }.to change(Post, :count).by(1)
      end

      it 'redirects to the created post' do
        post posts_path, params: valid_params
        expect(response).to redirect_to(Post.last)
      end
    end

    context 'when user is not signed in' do
      it 'redirects to sign in page' do
        post posts_path, params: valid_params
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'search functionality' do
    let!(:rails_post) { create(:post, title: 'Ruby on Rails Guide', published: true) }
    let!(:js_post) { create(:post, title: 'JavaScript Tips', published: true) }

    it 'returns posts matching search query' do
      get posts_path, params: { search: 'Rails' }
      expect(response.body).to include(rails_post.title)
      expect(response.body).not_to include(js_post.title)
    end
  end

  describe 'category filtering' do
    let(:category) { create(:category) }
    let!(:category_post) { create(:post, category: category, published: true) }

    it 'returns posts in the specified category' do
      get posts_path, params: { category_id: category.id }
      expect(response.body).to include(category_post.title)
    end
  end
end
