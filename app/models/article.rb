class Article < ApplicationRecord
  self.per_page = 5
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

  filterrific(
    default_filter_params: { sorted_by: 'created_at_desc' },
    available_filters: [
    :sorted_by,
    :search_query,
    :with_author_name,
    ]
    )

  def author
    @name = User.find(self.user_id).name
    @surname = User.find(self.user_id).surname
    return "#{@name} #{@surname}"
  end


scope :search_query, ->(query) {
    # Filters students whose name or email matches the query
    ...
  }
  scope :sorted_by, ->(sort_key) {
    # Sorts students by sort_key
    ...
  }
  scope :with_author_name, ->(user_ids) {
    # Filters students with any of the given country_ids
    where("users.name = ?", author_name).joins(:user)
}
  }
  scope :with_created_at_gte, ->(ref_date) {
    ...
  }

  # This method provides select options for the `sorted_by` filter select input.
  # It is called in the controller as part of `initialize_filterrific`.
  def self.options_for_sorted_by
    [
      ["Name (a-z)", "name_asc"],
      ["Updated at (newest first)", "updated_at_desc"],
      ["Updated at (oldest first)", "updated_at_asc"],
      ["Created at (newest first)", "created_at_desc"],
      ["Created at (oldest first)", "created_at_asc"],
      ["Author (a-z)", "author_name_asc"],
    ]
  end
  # def random_article
  #   @article = Article.all.sample
  # end
end
