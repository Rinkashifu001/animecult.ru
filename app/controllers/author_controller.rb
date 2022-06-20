class AuthorController < ApplicationController

  def show
    @author_search_limit = 20
    allow_params = params.permit(:id,:page)
    @author = Element.where(elem_type:4,link: allow_params[:id])[0]
    redirect_to(author_index_path) and return if @author.nil?
    @page = [1,allow_params[:page].to_i].max
    @serials = Serial.anime_list.where('serial_elements.element_id':@author.id).paginate(page:@page,per_page:36)
  end

  def index
    allow_params = params.permit(:page)
    @page = [1,allow_params[:page].to_i].max
    @authors = Element.by_elem_type(Element::AUTHOR_ID).paginate(page:@page)
  end

end
