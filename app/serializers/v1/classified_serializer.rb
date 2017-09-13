class V1::ClassifiedSerializer < ActiveModel::Serializer
  attributes :id, :title, :price, :description
  belongs_to :user
end
