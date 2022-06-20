class AnimeListController < ApplicationController
  def index
    allowed_params = params.permit(:search_key,:page)
    serial_stat = SerialStat.first
    min_release = serial_stat.min_release
    max_release = serial_stat.max_release
    @page = [allowed_params[:page].to_i,1].max
    @search_key = allowed_params[:search_key].to_s.strip
    @ru_letters = 'абвгдежзиклмнопрстуфхцчшщэюя'
    @title = "Полный каталог аниме. Русские названия."
    @serials = Serial.anime_list
    if @ru_letters.include?(@search_key)
      @serials = @serials.where("lower(title) like '#{@search_key}%'")
    elsif (min_release..max_release).include?(@search_key.to_i)
      @by_year = true
      @serials = @serials.where(release: @search_key.to_i)
    else
      @search_key = ''
    end
    @serials = @serials.paginate(page:@page,per_page:36)
  end
end
