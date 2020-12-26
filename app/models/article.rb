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
    :with_user_id,
    :with_created_at_gte,
    :with_updated_at_gte
    ]
    )

  def author
    @name = User.find(self.user_id).name
    @surname = User.find(self.user_id).surname
    return "#{@name} #{@surname}"
  end


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

  scope :search_query, ->(query) {
    return nil  if query.blank?
    terms = query.downcase.split(/\s+/)
    terms = terms.map { |e|
      (e.gsub('*', '%') + '%').gsub(/%+/, '%')
    }
    num_or_conditions = 3
    where(
      terms.map {
        or_clauses = [
          "LOWER(articles.title) LIKE ?",
          "LOWER(articles.text) LIKE ?",
          "LOWER(articles.author) LIKE ?"
        ].join(' OR ')
        "(#{ or_clauses })"
      }.join(' AND '),
      *terms.map { |e| [e] * num_or_conditions }.flatten
    )
  }

  scope :sorted_by, ->(sort_option) {
    # extract the sort direction from the param value.
    direction = (sort_option =~ /desc$/) ? 'desc' : 'asc'
    articles = Article.arel_table
    users = User.arel_table
    case sort_option.to_s
    when /^title_/
      order(articles[:title].lower.send(direction))
    when /^author_name_/
      Article.joins(:user).order(users[:surname].lower.send(direction)).order(users[:name].lower.send(direction))
    when /^updated_at_/
      order(articles[:updated_at].send(direction))
    when /^created_at_/
      order(articles[:created_at].send(direction))
    else
      raise(ArgumentError, "Invalid sort option: #{sort_option.inspect}")
    end
  }

  # scope :with_user_id, ->(user_ids) {
  #   where(:user_id => [*user_ids])
  # }
  scope :with_user_id, ->(user_id) {
    # Filters students with any of the given country_ids
  where(:user_id => [*user_ids]).joins(:user)
  }
  scope :with_created_at_gte, ->(ref_date) {
    where('articles.created_at >= ?', ref_date)
  }
  scope :with_updated_at_gte, ->(ref_date) {
    where('articles.updated_at >= ?', ref_date)
  }

  delegate :surname, :to => :user, :prefix => true

  def self.options_for_sorted_by
    [
      ['Title (a-z)', 'title_asc'],
      ['Title (z-a)', 'title_desc'],
      ['Author (a-z)', 'author_name_asc'],
      ['Author (z-a)', 'author_name_desc'],
      ['Created at (newest first)', 'created_at_desc'],
      ['Created at (oldest first)', 'created_at_asc'],
      ['Updated at (newest first)', 'created_at_desc'],
      ['Updated at (oldest first)', 'created_at_asc']
    ]
  end

  def full_name
    [surname, name].compact.join(', ')
  end

  def decorated_created_at
    created_at.to_date.to_s(:long)
  end

  def decorated_updated_at
    updated_at.to_date.to_s(:long)
  end

end
