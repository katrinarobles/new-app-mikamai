class Article < ApplicationRecord
  has_one_attached :photo
  belongs_to :user

  include PgSearch::Model
  pg_search_scope :search_by_title_text_author,
    against: [:title, :text],
    associated_against: {
    user: [:name, :surname]
    },
    using: {
      tsearch: { prefix: true }
    }

  def author
    @name = User.find(self.user_id).name
    @surname = User.find(self.user_id).surname
    return "#{@name} #{@surname}"
  end

  # def random_article
  #   @article = Article.all.sample
  # end
end
