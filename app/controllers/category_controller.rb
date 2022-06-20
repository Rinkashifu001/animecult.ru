class CategoryController < ApplicationController

  def show
    @category_search_limit = 20
    allow_params = params.permit(:id,:page)
    @category = Element.where(elem_type:2,link: allow_params[:id])[0]
    redirect_to(category_index_path) and return if @category.nil?
    @page = [1,allow_params[:page].to_i].max
    @serials = Serial.anime_list.where('serial_elements.element_id':@category.id).paginate(page:@page,per_page:36)
  end

  def index
    allow_params = params.permit(:page)
    page = allow_params[:page]
    @categories = Element.by_elem_type(Element::CATEGORY_ID).paginate(page:page)
  end
end
