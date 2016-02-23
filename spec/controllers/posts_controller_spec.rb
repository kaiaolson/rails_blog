require 'rails_helper'

RSpec.describe PostsController, type: :controller do

  let(:blog_post) { FactoryGirl.create(:post) }
  let(:user) { FactoryGirl.create(:user) }

  describe "#new" do
    context "with signed in user" do
      before do
        login(user)
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

    context "without signed in user" do
      it "redirects to the login page" do
        get :new
        expect(response).to redirect_to(new_session_path)
      end
    end
  end

  describe "#create" do
    context "with signed in user" do
      before {login(user)}

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
        it "associates the post with the current user" do
          valid_request
          expect(Post.last.user).to eq(user)
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

    context "without signed in user" do
      it "redirects to the login page" do
        post :create, FactoryGirl.attributes_for(:post)
        expect(response).to redirect_to(new_session_path)
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
    context "with signed in user" do
      before { login(user) }

      context "the current user created the post" do
        before do
          @b = FactoryGirl.create(:post, user_id: user.id)
          get :edit, id: @b.id
        end
        it "renders the edit template" do
          expect(response).to render_template(:edit)
        end
        it "finds the record by id and sets it equal to the @post instance variable" do
          expect(assigns(:post)).to eq(@b)
        end
      end

      context "the current user did not create the post" do
        before do
          u = FactoryGirl.create(:user)
          @b = FactoryGirl.create(:post, user_id: u.id)
          get :edit, id: @b.id
        end
        it "redirects to the home page" do
          expect(response).to redirect_to(root_path)
        end
        it "sets a flash alert message" do
          expect(flash[:alert]).to be
        end
      end
    end

    context "without signed in user" do
      before do
        get :edit, id: blog_post.id
      end
      it "redirects to the login page" do
        expect(response).to redirect_to(new_session_path)
      end
    end
  end

  describe "#update" do
    context "with signed in user" do
      before { login(user) }

      context "the current user created the post" do
        before do
          @b = FactoryGirl.create(:post, user_id: user.id)
          get :edit, id: @b.id
        end

        context "with valid attributes" do
          before { patch :update, id: @b.id, post: {title: "new title"} }
          it "redirects to the show template" do
            expect(response).to redirect_to(post_path(@b))
          end
          it "updates the record with new params" do
            expect(@b.reload.title).to eq("new title")
          end
          it "sets a flash notice message" do
            expect(flash[:notice]).to be
          end
        end

        context "with invalid attributes" do
          def invalid_request
            patch :update, id: @b.id, post: {title: "short"}
          end
          it "renders the edit template" do
            invalid_request
            expect(response).to render_template(:edit)
          end
          it "doesn't update the record" do
            title_before = @b.title
            invalid_request
            title_after = @b.title
            expect(title_before).to eq(title_after)
          end
          it "sets a flash alert message" do
            invalid_request
            expect(flash[:alert]).to be
          end
        end

      end

      context "the current user did not create the post" do
        before do
          u = FactoryGirl.create(:user)
          @b = FactoryGirl.create(:post, user_id: u.id)
          get :edit, id: @b.id
        end

        it "redirects to the home page" do
          expect(response).to redirect_to(root_path)
        end
        it "sets a flash alert message" do
          expect(flash[:alert]).to be
        end

      end

    end

    context "without signed in user" do
      it "redirects to the login page" do
        patch :update, id: blog_post.id, post: {title: "new title"}
        expect(response).to redirect_to(new_session_path)
      end
    end
  end

  describe "#destroy" do
    context "with signed in user" do
      before {login(user)}

      context "the current user created the post" do
        before do
          @b = FactoryGirl.create(:post, user_id: user.id)
          get :edit, id: @b.id
        end

        it "redirects to the index page" do
          delete :destroy, id: @b
          expect(response).to redirect_to(posts_path)
        end
        it "destroys the record" do
          post_count_before = Post.count
          delete :destroy, id: @b
          post_count_after = Post.count
          expect(post_count_before - post_count_after).to eq(1)
        end
        it "sets a flash notice message" do
          delete :destroy, id: @b
          expect(flash[:notice]).to be
        end
      end

      context "the current user did not create the post" do
        before do
          u = FactoryGirl.create(:user)
          @b = FactoryGirl.create(:post, user_id: u.id)
          get :edit, id: @b.id
        end

        it "redirects to the home page" do
          expect(response).to redirect_to(root_path)
        end
        it "sets a flash alert message" do
          expect(flash[:alert]).to be
        end

      end
    end

    context "without signed in user" do
      it "redirects to the login page" do
        delete :destroy, id: blog_post
        expect(response).to redirect_to(new_session_path)
      end
    end
  end

end
