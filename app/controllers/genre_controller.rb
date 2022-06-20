class GenreController < ApplicationController
  include ApplicationHelper
  def show
    @genre_search_limit = 20
    allow_params = params.permit(:id,:page)
    @genre = Element.where(elem_type:1,link: allow_params[:id])[0]
    redirect_to(genre_index_path) and return if @genre.nil?
    @page = [1,allow_params[:page].to_i].max
    @serials = Serial.anime_list.where('serial_elements.element_id':@genre.id).paginate(page:@page,per_page:36)
  end

  def index
    allow_params = params.permit(:page)
    @page = [1,allow_params[:page].to_i].max
    @genres = Element.by_elem_type(Element::GENRE_ID).paginate(page:@page)
  end
end
