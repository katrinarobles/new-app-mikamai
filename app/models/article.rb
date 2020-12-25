class Article < ApplicationRecord
  belongs_to :user
  attr_reader :author

  def author
    @name = User.find(self.user_id).name
    @surname = User.find(self.user_id).surname
    return "#{@name} #{@surname}"
  end
end
