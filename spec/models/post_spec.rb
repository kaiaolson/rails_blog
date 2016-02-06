require 'rails_helper'

RSpec.describe Post, type: :model do
  describe "validations" do
    it "requires a title" do
      p = Post.new
      p.valid?
      expect(p.errors).to have_key(:title)
    end
    it "requires a title more than 7 characters" do
      p = Post.new(title: "hello")
      p.valid?
      expect(p.errors).to have_key(:title)
    end
    it "requires a body" do
      p = Post.new
      p.valid?
      expect(p.errors).to have_key(:body)
    end
  end
  
  describe ".body_snippet" do
    context "when post has a long body" do
      it "creates a snippet" do
        p = Post.new(body: Faker::Lorem.paragraph)
        snippet_length = p.body_snippet.length
        expect(snippet_length).to eq(100)
      end
    end
  end
end
