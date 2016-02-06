require 'rails_helper'

RSpec.describe PostsController, type: :controller do

  let(:blog_post) { FactoryGirl.create(:post) }

  describe "#new" do
    before do
      get :new
    end
    it "renders the new template" do
      get :new
      expect(response).to render_template(:new)
    end
    it "instantiates a new Post and sets it equal to @post" do
      expect(assigns(:post)).to be_a_new(Post)
    end
  end

  describe "#create" do
    context "with valid attributes" do
      def valid_request
        post :create, post: {title: "test title", body: "test body"}
      end
      it "creates a record in the database" do
        post_count_before = Post.count
        valid_request
        post_count_after = Post.count
        expect(post_count_after - post_count_before).to eq(1)
      end
      it "redirects to the post show page" do
        valid_request
        expect(response).to redirect_to(post_path(Post.last))
      end
      it "sets a flash notice message" do
        valid_request
        expect(flash[:notice]).to be
      end
    end

    context "with invalid attributes" do
      def invalid_request
        post :create, post: {title: "short", body: "test body"}
      end
      it "renders the new template" do
        invalid_request
        expect(response).to render_template(:new)
      end
      it "doesn't create a record in the database" do
        post_count_before = Post.count
        invalid_request
        post_count_after = Post.count
        expect(post_count_after - post_count_before).to eq(0)
      end
      it "sets a flash alert message" do
        invalid_request
        expect(flash[:alert]).to be
      end
    end

  end

  describe "#show" do
    before do
      blog_post
      get :show, id: blog_post.id
    end
    it "renders the show template" do
      expect(response).to render_template(:show)
    end
    it "finds the record by id and sets it equal to the @post instance variable" do
      expect(assigns(:post)).to eq(blog_post)
    end
    it "raises an error if the id passed doesn't match an id in the database" do
      expect { get :show, id: 93024893028}.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe "#index" do
    before do
      get :index
    end
    it "renders the index template" do
      expect(response).to render_template(:index)
    end
    it "fetches all records and sets them equal to the @posts instance variable" do
      p1 = FactoryGirl.create(:post)
      p2 = FactoryGirl.create(:post)
      expect(assigns(:posts)).to eq([p1, p2])
    end
  end

  describe "#edit" do
    before do
      blog_post
      get :edit, id: blog_post.id
    end
    it "renders the edit template" do
      expect(response).to render_template(:edit)
    end
    it "finds the record by id and sets it equal to the @post instance variable" do
      expect(assigns(:post)).to eq(blog_post)
    end
  end

  describe "#update" do
    context "with valid attributes" do
      def valid_request
        patch :update, id: blog_post.id, post: {title: "new title"}
      end
      it "redirects to the show template" do
        valid_request
        expect(response).to redirect_to(post_path(blog_post))
      end
      it "updates the record with new params" do
        valid_request
        expect(blog_post.reload.title).to eq("new title")
      end
      it "sets a flash notice message" do
        valid_request
        expect(flash[:notice]).to be
      end
    end

    context "with invalid attributes" do
      def invalid_request
        patch :update, id: blog_post.id, post: {title: "short"}
      end
      it "renders the edit template" do
        invalid_request
        expect(response).to render_template(:edit)
      end
      it "doesn't update the record" do
        title_before = blog_post.title
        invalid_request
        title_after = blog_post.title
        expect(title_before).to eq(title_after)
      end
      it "sets a flash alert message" do
        invalid_request
        expect(flash[:alert]).to be
      end
    end
  end

  describe "#destroy" do
    it "redirects to the index page" do
      delete :destroy, id: blog_post
      expect(response).to redirect_to(posts_path)
    end
    it "destroys the record" do
      blog_post
      post_count_before = Post.count
      delete :destroy, id: blog_post
      post_count_after = Post.count
      expect(post_count_before - post_count_after).to eq(1)
    end
    it "sets a flash notice message" do
      delete :destroy, id: blog_post
      expect(flash[:notice]).to be
    end
  end

end
