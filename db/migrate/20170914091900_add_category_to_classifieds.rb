class AddCategoryToClassifieds < ActiveRecord::Migration[5.1]
  def change
    add_column :classifieds, :category, :string
  end
end
