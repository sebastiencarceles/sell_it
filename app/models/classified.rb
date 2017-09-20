class Classified < ApplicationRecord
  belongs_to :user

  validates_presence_of :user, :title, :price, :description
  validates_numericality_of :price

  scope :by_category, ->(category) { where(category: category) }
  scope :by_title_query, ->(title_query) { where('title like ?', "%#{title_query}%") }
end
