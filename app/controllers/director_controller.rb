class DirectorController < ApplicationController

  def show
    @director_search_limit = 20
    allow_params = params.permit(:id,:page)
    @director = Element.where(elem_type:3,link: allow_params[:id])[0]
    redirect_to(director_index_path) and return if @director.nil?
    @page = [1,allow_params[:page].to_i].max
    @serials = Serial.anime_list.where('serial_elements.element_id':@director.id).paginate(page:@page,per_page:36)
  end

  def index
    allow_params = params.permit(:page)
    @page = [1,allow_params[:page].to_i].max
    @directors = Element.by_elem_type(Element::DIRECTOR_ID).paginate(page:@page)
  end
end
