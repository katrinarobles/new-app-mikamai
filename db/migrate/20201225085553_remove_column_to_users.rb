class RemoveColumnToUsers < ActiveRecord::Migration[6.1]
  def change
    remove_column :users, :field_name
  end
end
