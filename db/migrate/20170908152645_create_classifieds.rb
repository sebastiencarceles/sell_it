class CreateClassifieds < ActiveRecord::Migration[5.1]
  def change
    create_table :classifieds do |t|
      t.string :title
      t.integer :price
      t.text :description

      t.timestamps
    end
  end
end
