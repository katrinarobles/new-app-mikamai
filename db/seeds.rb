# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'faker'
require 'json'
require 'open-uri'

User.destroy_all
Article.destroy_all

url = 'https://source.unsplash.com/700x700/?face'
url_article = 'https://source.unsplash.com/700x700/?new'


puts 'Creating 5 fake users...'

u_count = 1
5.times do
  file = URI.open(url)
  user = User.new(
    email: "user#{u_count}@email.com",
    password: "123456",
    name: "#{Faker::Name.unique.first_name}",
    surname: "#{Faker::Name.last_name}",
    admin: false,
  )
  user.photo.attach(io: file, filename: "user#{u_count}.png", content_type: 'image/png')
  u_count += 1
  user.save
end
puts 'Finished!'

puts 'Creating 5 articles for each user'
c_count = 0
User.all.each do |user|
  4.times do
    file_article = URI.open(url_article)
    article = Article.new(
      title: "#{Faker::Hipster.sentence(word_count: 3)}",
      text: "#{Faker::Hipster.paragraph_by_chars(characters: 1200, supplemental: false)}",
    )
    article.photo.attach(io: file_article, filename: "article#{c_count}.png", content_type: 'image/png')
    c_count += 1
    article.user = user
    article.save
  end
end

puts 'Finished!'
