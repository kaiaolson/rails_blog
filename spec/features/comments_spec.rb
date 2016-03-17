require 'rails_helper'

RSpec.feature "Comments", type: :feature do
  let(:user) { FactoryGirl.create(:user) }
  let(:post) { FactoryGirl.create(:post) }
  let(:comment) { FactoryGirl.create(:comment, {post: post}) }

  describe "Create Comment" do
    before{ login_via_web(user) }
    context "with valid attributes" do
      it "displays the comment on the post page" do
        visit post_path(post.id)

        fill_in "Body", with: "New Comment"
        click_button "Create Comment"

        expect(page).to have_text("New Comment")
        expect(page).to have_text /comment created/i
      end
    end

    context "with invalid attributes" do
      context "with empty body" do
        it "adds class 'has-error' to the comment form group for the input" do
          visit post_path(post.id)
          click_button "Create Comment"

          expect(page).to have_selector('.form-group.has-error')
          expect(page).to have_text /can't be blank/i
        end
      end
      context "with body that's not unique to the post" do
        it "adds class 'has-error' to the comment form group for the input / doesn't show the comment on the page" do
          visit post_path(post.id)

          fill_in "Body", with: comment.body
          click_button "Create Comment"

          expect(page).to have_selector('.form-group.has-error')
          expect(page).to have_text /body has already been taken/i
        end
      end
    end

  end
end
