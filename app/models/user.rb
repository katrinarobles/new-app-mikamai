class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_one_attached :photo
  has_many :articles, dependent: :destroy

  def self.options_for_select
    order("LOWER(name)").map { |e| [e.name, e.surname, e.id] }
  end
end
