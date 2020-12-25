class AddTitletoArticles < ActiveRecord::Migration[6.1]
  def change
    add_column :articles, :title, :string
  end
end
