
require 'faker'
require 'json'
require 'open-uri'
require 'pry'

User.destroy_all
Article.destroy_all

url = 'https://source.unsplash.com/700x700/?face'
# url_article = 'https://source.unsplash.com/700x700/?new'



puts 'Creating 5 fake users...'

u_count = 1
3.times do
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

# puts 'Creating 5 articles for each user'
# c_count = 0
# User.all.each do |user|
#   4.times do
#     file_article = URI.open(url_article)
#     article = Article.new(
#       title: "#{Faker::Hipster.sentence(word_count: 3)}",
#       text: "#{Faker::Hipster.paragraph_by_chars(characters: 1200, supplemental: false)}",
#     )
#     article.photo.attach(io: file_article, filename: "article#{c_count}.png", content_type: 'image/png')
#     c_count += 1
#     article.user = user
#     article.save
#   end
# end

# puts 'Finished!'
puts "Creating articles for users"

api_key = "52e52aec44c84a94905af03a0e830258"
url = "http://newsapi.org/v2/top-headlines?sources=techcrunch&apiKey=#{api_key}"
articles_serialized = open(url).read
articles_parse = JSON.parse(articles_serialized)
# Pry::ColorPrinter.pp(articles_parse)

articles = articles_parse["articles"]
# Pry::ColorPrinter.pp(articles)
c_count = 0

User.all.each do |user|
  3.times do
    article = articles[c_count]
    title = article["title"]
    content = article["content"]
    content_url = article["url"]
    file = URI.open(article["urlToImage"])
    new_article = Article.new(
      title: title,
      text: content,
      url: content_url
      )
    new_article.photo.attach(io: file, filename: "article#{c_count}.png", content_type: 'image/png')
    c_count += 1
    new_article.user_id = user.id
    new_article.save
  end
end

puts 'Finish'
