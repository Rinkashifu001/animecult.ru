class VideoController < ApplicationController
  def show
    allowed_params = params.permit(:id)
    id = allowed_params[:id].to_i
    videos = Video.where(id:id)
    (render(text: '') && return) unless videos.size==1
    @video = videos[0]
    render plain: @video.video_url.gsub('http://','https://')
  end

end
