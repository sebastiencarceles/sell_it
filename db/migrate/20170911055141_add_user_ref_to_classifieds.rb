class AddUserRefToClassifieds < ActiveRecord::Migration[5.1]
  def change
    add_reference :classifieds, :user, foreign_key: true
  end
end
