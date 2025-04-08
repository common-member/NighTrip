class TagsController < ApplicationController
  def autocomplete
    query = params[:q]
    tags = Tag.where("name ILIKE ?", "%#{query}%").select(:name).distinct.limit(10)
    render json: tags.map { |tag| { id: nil, name: tag.name } }
  end
end
