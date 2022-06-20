class PersonalController < ApplicationController

  def show
    code = params[:id].to_s
    @personal = Personal.first_by_code(code)
    (render('not_found/index',status: 404) && return) if @personal.blank?
    @videos = Video.includes(:translator).where(serial_id:@personal.serial_id,chapter_id:@personal.chapter_id).order('video_date desc')
  end

  def ajax
    code = params[:code].to_s
    id = params[:id].to_i
    @personal = Personal.first_by_code(code)
    if @personal.blank?
      if user_signed_in?
        @video = Video.find(id)
      else
        (render(plain: '') && return)
      end
    else
      @video = Video.where(serial_id:@personal.serial_id,chapter_id:@personal.chapter_id,id:id)[0]
      (render(plain: '') && return) if @video.blank?
    end
    render plain: @video.video_url.gsub('http://','https://')
  end

end
