class Article < ApplicationRecord
  belongs_to :user
  attr_reader :author

  def author
    User.find(self.user_id).surname
  end
end
