class RemoveFullnameFromUsers < ActiveRecord::Migration[5.1]
  def change
    remove_column :users, :fullname, :string
  end
end
