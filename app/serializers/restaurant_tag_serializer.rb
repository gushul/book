class RestaurantTagSerializer < ActiveModel::Serializer
  attributes :id, :title, :tag_value 

  def tag_value
    object.title[title.index(':')+1..title.length]
  end

end
