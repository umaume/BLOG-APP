require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:post_record) { create(:post) }
  let(:comment) { create(:comment, user: user, post: post_record) }

  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  describe 'POST #create' do
    let(:valid_attributes) do
      {
        body: 'This is a test comment that should be long enough to pass validation.',
      }
    end

    let(:invalid_attributes) do
      {
        body: '',
      }
    end

    context 'when user is authenticated' do
      before { sign_in user }

      context 'with valid parameters' do
        it 'creates a new Comment' do
          expect {
            post :create, params: { post_id: post_record.id, comment: valid_attributes }
          }.to change(Comment, :count).by(1)
        end

        it 'assigns the comment to the current user and post' do
          post :create, params: { post_id: post_record.id, comment: valid_attributes }
          created_comment = Comment.last
          expect(created_comment.user).to eq(user)
          expect(created_comment.post).to eq(post_record)
        end

        it 'redirects to the post' do
          post :create, params: { post_id: post_record.id, comment: valid_attributes }
          expect(response).to redirect_to(post_record)
        end
      end

      context 'with invalid parameters' do
        it 'does not create a new Comment' do
          expect {
            post :create, params: { post_id: post_record.id, comment: invalid_attributes }
          }.to_not change(Comment, :count)
        end

        it 'redirects to the post with errors' do
          post :create, params: { post_id: post_record.id, comment: invalid_attributes }
          expect(response).to redirect_to(post_record)
        end
      end
    end

    context 'when user is not authenticated' do
      it 'redirects to sign in' do
        post :create, params: { post_id: post_record.id, comment: valid_attributes }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'PATCH #update' do
    let(:new_attributes) do
      {
        body: 'This is an updated comment body that is long enough.',
      }
    end

    context 'when user owns the comment' do
      before { sign_in user }

      context 'with valid parameters' do
        it 'updates the requested comment' do
          patch :update, params: { post_id: post_record.id, id: comment.id, comment: new_attributes }
          comment.reload
          expect(comment.body).to eq('This is an updated comment body that is long enough.')
        end

        it 'redirects to the post' do
          patch :update, params: { post_id: post_record.id, id: comment.id, comment: new_attributes }
          expect(response).to redirect_to(post_record)
        end
      end

      context 'with invalid parameters' do
        it 'renders unprocessable content status' do
          patch :update, params: { post_id: post_record.id, id: comment.id, comment: { body: '' } }
          expect(response).to have_http_status(:unprocessable_content)
        end
      end
    end

    context 'when user does not own the comment' do
      before { sign_in other_user }

      it 'redirects to the post' do
        patch :update, params: { post_id: post_record.id, id: comment.id, comment: new_attributes }
        expect(response).to redirect_to(post_record)
      end

      it 'does not update the comment' do
        original_body = comment.body
        patch :update, params: { post_id: post_record.id, id: comment.id, comment: new_attributes }
        comment.reload
        expect(comment.body).to eq(original_body)
      end
    end

    context 'when user is not authenticated' do
      it 'redirects to sign in' do
        patch :update, params: { post_id: post_record.id, id: comment.id, comment: new_attributes }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'when user owns the comment' do
      before { sign_in user }

      it 'destroys the requested comment' do
        comment_to_delete = create(:comment, user: user, post: post_record)
        expect {
          delete :destroy, params: { post_id: post_record.id, id: comment_to_delete.id }
        }.to change(Comment, :count).by(-1)
      end

      it 'redirects to the post' do
        delete :destroy, params: { post_id: post_record.id, id: comment.id }
        expect(response).to redirect_to(post_record)
      end
    end

    context 'when user does not own the comment' do
      before { sign_in other_user }

      it 'redirects to the post' do
        comment # create the comment first
        delete :destroy, params: { post_id: post_record.id, id: comment.id }
        expect(response).to redirect_to(post_record)
      end

      it 'does not destroy the comment' do
        comment # create the comment first
        expect {
          delete :destroy, params: { post_id: post_record.id, id: comment.id }
        }.to_not change(Comment, :count)
      end
    end

    context 'when user is not authenticated' do
      it 'redirects to sign in' do
        delete :destroy, params: { post_id: post_record.id, id: comment.id }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
