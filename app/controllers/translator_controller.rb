class TranslatorController < ApplicationController
  include ApplicationHelper

  def show
    @translator_search_limit = 20
    allow_params = params.permit(:id,:page)
    full_link = "/list/person/#{allow_params[:id]}"
    @translator = Translator.where(link:full_link)[0]
    redirect_to(translator_index_path) and return if @translator.nil?
    @page = [1,allow_params[:page].to_i].max
    serial_ids = @translator.serials.map(&:id)
    @serials = Serial.anime_list.where(id:serial_ids).paginate(page:@page,per_page:36)
  end

  def index
    allow_params = params.permit(:page)
    @page = [1,allow_params[:page].to_i].max
    @translators = Translator.where("position('/list/person/' in link)>0").order(:title).paginate(page:@page)
  end
end
