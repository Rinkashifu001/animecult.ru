class StudioController < ApplicationController
  include ApplicationHelper
  def show
    @studio_search_limit = 20
    allow_params = params.permit(:id,:page)
    @studio = Element.where(elem_type:5,link: allow_params[:id])[0]
    redirect_to(studio_index_path) and return if @studio.nil?
    @page = [1,allow_params[:page].to_i].max
    @serials = Serial.anime_list.where('serial_elements.element_id':@studio.id).paginate(page:@page,per_page:36)
  end

  def index
    allow_params = params.permit(:page)
    @page = [1,allow_params[:page].to_i].max
    @studios = Element.by_elem_type(Element::STUDIO_ID).paginate(page:@page)
  end
end
