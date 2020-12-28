class Article < ApplicationRecord
  has_one_attached :photo
  belongs_to :user
  attr_reader :author

  include PgSearch::Model
  pg_search_scope :search_by_title_text_author,
    against: [:title, :text],
    associated_against: {
    user: [:name, :surname]
    },
    using: {
      tsearch: { prefix: true }
    }

  def self.search(search)
      if search
          where("surname ILIKE ?", "%#{search}%").or(where("name ILIKE? ", "%#{search}%")).or(where("title ILIKE ?", "%#{search}%")).or(where("text ILIKE ?", "%#{search}%"))
          # Article.joins(:user).where("surname ILIKE ?", "%#{search}%")
      else
        all
      end
  end

  def author
      @name = User.find(self.user_id).name
      @surname = User.find(self.user_id).surname
      return "#{@name} #{@surname}"
  end
end
