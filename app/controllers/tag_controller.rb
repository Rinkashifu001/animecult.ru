class TagController < ApplicationController
  def show
    per_page = 60
    allow_params = params.permit(:id,:page)
    @tag = Tag.find(allow_params[:id])
    @page = [1,allow_params[:page].to_i].max
    @de = @tag.description_elements.includes(:description).order(:description_type,:description_id).paginate(page:@page,per_page:per_page)
  end
end
