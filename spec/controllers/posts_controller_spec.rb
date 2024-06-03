# spec/controllers/posts_controller_spec.rb
require 'rails_helper'

RSpec.describe PostsController, type: :controller do
  let(:valid_attributes) {
    { title: 'Test Post', content: 'This is a test post.', author: 'John Doe' }
  }

  let(:invalid_attributes) {
    { title: '', content: 'This is a test post.', author: 'John Doe' }
  }

  let(:new_attributes) {
    { title: 'Updated Post', content: 'This is an updated test post.', author: 'Jane Doe' }
  }

  describe 'GET #index' do
    it 'assigns all posts as @posts' do
      post = Post.create! valid_attributes
      get :index
      expect(assigns(:posts)).to eq([post])
    end
  end

  describe 'GET #show' do
    it 'assigns the requested post as @post' do
      post = Post.create! valid_attributes
      get :show, params: { id: post.to_param }
      expect(assigns(:post)).to eq(post)
    end
  end

  describe 'GET #new' do
    it 'assigns a new post as @post' do
      get :new
      expect(assigns(:post)).to be_a_new(Post)
    end
  end

  describe 'GET #edit' do
    it 'assigns the requested post as @post' do
      post = Post.create! valid_attributes
      get :edit, params: { id: post.to_param }
      expect(assigns(:post)).to eq(post)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Post' do
        expect {
          post :create, params: { post: valid_attributes }
        }.to change(Post, :count).by(1)
      end

      it 'assigns a newly created post as @post' do
        post :create, params: { post: valid_attributes }
        expect(assigns(:post)).to be_a(Post)
        expect(assigns(:post)).to be_persisted
      end

      it 'redirects to the created post' do
        post :create, params: { post: valid_attributes }
        expect(response).to redirect_to(Post.last)
      end
    end

    context 'with invalid params' do
      it 'does not create a new Post' do
        expect {
          post :create, params: { post: invalid_attributes }
        }.to_not change(Post, :count)
      end

      it 'assigns a newly created but unsaved post as @post' do
        post :create, params: { post: invalid_attributes }
        expect(assigns(:post)).to be_a_new(Post)
      end

      it 're-renders the new template' do
        post :create, params: { post: invalid_attributes }
        expect(response).to render_template('new')
      end
    end
  end

  describe 'PATCH #update' do
    context 'with valid params' do
      it 'updates the requested post' do
        post = Post.create! valid_attributes
        patch :update, params: { id: post.to_param, post: new_attributes }
        post.reload
        expect(post.title).to eq('Updated Post')
        expect(post.content).to eq('This is an updated test post.')
        expect(post.author).to eq('Jane Doe')
      end

      it 'assigns the requested post as @post' do
        post = Post.create! valid_attributes
        patch :update, params: { id: post.to_param, post: new_attributes }
        expect(assigns(:post)).to eq(post)
      end

      it 'redirects to the post' do
        post = Post.create! valid_attributes
        patch :update, params: { id: post.to_param, post: new_attributes }
        expect(response).to redirect_to(post)
      end
    end

    context 'with invalid params' do
      it 'assigns the post as @post' do
        post = Post.create! valid_attributes
        patch :update, params: { id: post.to_param, post: invalid_attributes }
        expect(assigns(:post)).to eq(post)
      end

      it 're-renders the edit template' do
        post = Post.create! valid_attributes
        patch :update, params: { id: post.to_param, post: invalid_attributes }
        expect(response).to render_template('edit')
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested post' do
      post = Post.create! valid_attributes
      expect {
        delete :destroy, params: { id: post.to_param }
      }.to change(Post, :count).by(-1)
    end

    it 'redirects to the posts list' do
      post = Post.create! valid_attributes
      delete :destroy, params: { id: post.to_param }
      expect(response).to redirect_to(posts_url)
    end

    it 'handles non-existing post gracefully' do
      expect {
        delete :destroy, params: { id: 'non-existing-id' }
      }.to_not change(Post, :count)
      expect(response).to redirect_to(posts_url)
      expect(flash[:alert]).to eq('The post you were looking for could not be found.')
    end
  end
end
