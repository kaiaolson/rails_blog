require 'rails_helper'

RSpec.feature "Posts", type: :feature do
  let(:user) { FactoryGirl.create(:user) }
  let(:post) { FactoryGirl.create(:post, {user: user}) }
  let(:post_b) { FactoryGirl.create(:post) }

  describe "Create Post" do
    before { login_via_web(user) }
    context "with valid attributes" do
      it "goes to the post show page / it shows message 'post created'" do
        visit new_post_path

        valid_post = FactoryGirl.attributes_for(:post)

        fill_in "Title", with: valid_post[:title]
        fill_in "Body", with: valid_post[:body]

        click_button "Create Post"

        expect(current_path).to eq(post_path(Post.last.friendly_id))
        expect(page).to have_text /post created/i
      end

    end

    context "with invalid attributes" do
      it "shows the create post page / it shows a message 'post not created'" do
        visit new_post_path

        fill_in "Body", with: "testing body"

        click_button "Create Post"

        expect(current_path).to eq(new_post_path)
        expect(page).to have_text /post not created/i
      end
    end
  end

  describe "Edit Post" do
    before { login_via_web(user) }
    it "displays the post show page / it displays the message 'post updated' / it displays the post with changes" do
      visit edit_post_path(post.id)

      fill_in "Title", with: "New Title"
      click_button "Update Post"

      expect(current_path).to eq("/posts/new-title")
      expect(page).to have_text /post updated/i
      expect(page).to have_text "New Title"
    end

  end

  describe "Delete Post" do
    before { login_via_web(user) }
    context "user owns the post" do
      it "displays the all posts page / it displays a message 'your post was deleted'" do
        visit post_path(post.id)
        click_link "Delete"

        expect(current_path).to eq(posts_path)
        expect(page).to have_text /your post was deleted/i
      end
    end
    # this won't pass unless you comment out the if can destroy statement on the post show page
    # because that shows/hides the delete link itself
    context "user doesn't own the post" do
      it "displays the home page / it displays a message 'access denied'" do
        visit post_path(post_b.id)
        click_link "Delete"

        expect(current_path).to eq(root_path)
        expect(page).to have_text /access denied/i
      end

    end
  end
end
