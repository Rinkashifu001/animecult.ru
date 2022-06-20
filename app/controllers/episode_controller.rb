class EpisodeController < ApplicationController

  before_action :access_deny_if_not_a_user, only: [:edit, :update, :new, :create,:create_chapter_link,:create_chapter_video]
  before_action :set_chapter, only: [:edit, :update, :destroy, :create_chapter_link, :create_chapter_video,:toggle_hide_to_unregistered]
  before_action :set_serial, only: [:new, :create,:cancel_chapter_link,:cancel_chapter_video]
  before_action :access_deny_if_could_not_moderate, only: [:destroy,:cancel_chapter_link,:cancel_chapter_video]
  before_action :access_deny_if_not_an_admin, only: [:toggle_hide_to_unregistered]

  def new
    @chapter = Chapter.new
  end

  def destroy
    serial = @chapter.serial
    chapter_id = @chapter.chapter_id
    @chapter.destroy
    redirect_to(serial_path(serial.transliterated_link),notice: "Эпизод #{chapter_id} удален")
  end

  def create
    @chapter = Chapter.new(chapter_params)
    @chapter.serial_id = @serial.id
    if @chapter.save
      unless current_user.moderation_available?
        @chapter.update_attribute(:is_applied, false)
      end
      @chapter.update_attribute( :account_id,current_user.account.id)
      redirect_to(serial_episode_path(@chapter.serial.transliterated_link,@chapter.chapter_id))
    else
      render 'new'
    end

  end

  def show
    @serial = Serial.where(transliterated_link: params[:serial_id]).first
    @chapter = Chapter.where(serial_id: @serial.id,chapter_id: params[:id]).first
    commontator_thread_show(@serial)
    if user_signed_in?
      @videos = Video.includes(:translator).where(serial_id:@serial.id,chapter_id:@chapter.chapter_id,is_cancelled:false,is_applied:true).order('video_date desc')
    end
    @chapter_links = ChapterLink.includes(:account).where(chapter:@chapter,is_cancelled:false,is_applied:true)

    @chapters = Chapter.where(serial_id:@serial.id).order(:chapter_id)



    Notification.where(correctable:@chapter,account:current_user.account).update_all(shown:true) if user_signed_in?

    @seo_obj = @chapter
  end

  def edit

  end

  def update
    update_result = @chapter.process_save(current_user,chapter_params.to_hash)
    if update_result
      redirect_to(serial_episode_path(@chapter.serial.transliterated_link,@chapter.chapter_id),notice: update_result)
    else
      render action: 'edit'
    end
  end

  def create_chapter_link
    link = params[:link].to_s
    render(json: {status:'error',message:ChapterLink::ERROR_BLANK})&&return if link.blank?
    render(json: {status:'error',message:ChapterLink::ERROR_NO_SPACE})&&return if link.include?(' ')
    render(json:{status:'error',message:ChapterLink::ERROR_HTTPS})&&return unless link.start_with?('https://')
    title = link.split('https://')[-1].split('/')[0]
    title = title.blank? ? ChapterLink::DEFAULT_TITLE : title
    ChapterLink.create(title:title,link:link,account:current_user.account,chapter:@chapter,is_applied:!current_user.only_could_revise?)
    message = current_user.only_could_revise? ? ChapterLink::MESSAGE_NOT_APPLIED : ChapterLink::MESSAGE_APPLIED
    render(json: {status:'moderate',message:message})&&return if current_user.only_could_revise?

    chapter_links = ChapterLink.includes(:account).where(chapter:@chapter)
    render json:{status:'ok',message:message}
  end

  def cancel_chapter_link
    chapter_link = ChapterLink.find(params[:chapter_link_id])
    chapter_link.update_attribute(:is_cancelled,true)
    redirect_to(serial_episode_path(serial_id:@serial.transliterated_link,chapter_id:params[:chapter_id]))
  end

  def create_chapter_video
    link = params[:link].to_s
    render(json: {status:'error',message:ChapterLink::ERROR_BLANK})&&return if link.blank?
    render(json: {status:'error',message:ChapterLink::ERROR_NO_SPACE})&&return if link.include?(' ')
    render(json:{status:'error',message:ChapterLink::ERROR_HTTPS})&&return unless link.start_with?('https://')
    video_url = "<iframe src='#{safe_link(link)}' webkitallowfullscreen='' mozallowfullscreen='' allowfullscreen='' scrolling='no'></iframe>"
    source_raw = link.split('//')[-1].split('/')[0].downcase
    source = Video::SOURCE_DATA.include?(source_raw) ? source_raw : Video::DEFAULT_SOURCE
    details_value = params[:details].to_i
    if details_value>=0 && details_value<Video::DETAILS_DATA.keys.size
      details = Video::DETAILS_DATA.keys[details_value]
    else
      details = Video::DEFAULT_DETAILS
    end
    Video.create(serial_id:@chapter.serial.id,chapter_id:@chapter.chapter_id,video_date:Time.now,video_url:video_url,details:details,source:source,
                 link:Video::LINK_WEBSITE,is_applied:!current_user.only_could_revise?,account:current_user.account)
    message = current_user.only_could_revise? ? Video::MESSAGE_NOT_APPLIED : Video::MESSAGE_APPLIED

    render(json: {status:'moderate',message:message})&&return if current_user.only_could_revise?
    videos = Video.includes(:translator).where(serial_id:@chapter.serial.id,chapter_id:@chapter.chapter_id,is_cancelled:false,is_applied:true).order('video_date desc')
    render json:{status:'ok',message:message}

  end

  def cancel_chapter_video
    video = Video.find(params[:video_id])
    video.update_attribute(:is_cancelled,true) if video.link==Video::LINK_WEBSITE
    redirect_to(serial_episode_path(serial_id:@serial.transliterated_link,chapter_id:params[:chapter_id]))
  end

  def toggle_hide_to_unregistered
    @chapter.hide_to_unregistered = !@chapter.hide_to_unregistered
    @chapter.save
    redirect_to(serial_episode_path(serial_id:@chapter.serial.transliterated_link,id:@chapter.chapter_id))
  end

  private
  def set_chapter
    @chapter = Chapter.find(params[:id])
  end

  def set_serial
    @serial = Serial.where(transliterated_link: params[:serial_id])[0]
  end

  def chapter_params
    params[:chapter][:description] = cure_froala(params[:chapter][:description])
    params.require(:chapter).permit(:title,:description,:chapter_id)
  end

end