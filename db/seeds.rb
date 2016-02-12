# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# 100.times do
#   Post.create(title: Faker::Lorem.sentence, body: Faker::Lorem.paragraph)
# end
#
# 100.times do
#   blog_post = Post.create title: Faker::Company.catch_phrase,
#                           body: Faker::Lorem.paragraph
#   5.times do
#     blog_post.comments.create(body: Faker::Company.bs)
#   end
# end

["Style","Technology","Nature","Photography"].each do |cat|
  Category.create(title: cat)
end
