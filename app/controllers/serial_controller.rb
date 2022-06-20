class SerialController < ApplicationController

  before_action :access_deny_if_not_a_user, only: [:rate, :edit, :update, :new, :create]
  before_action :set_serial, only: [:edit, :update, :translate, :toggle_hide_to_unregistered]
  before_action :access_deny_if_not_an_admin, only: [:toggle_hide_to_unregistered]

  def new
    @serial = Serial.new
  end

  def create
    @serial = Serial.new(serial_params)
    if @serial.save
      unless params[:attachments].blank?
        params[:attachments]['cover'].each do |cover|
          @serial.attachments.create!(cover: cover, main_object: @serial, is_applied: true, user: current_user)
        end
      end
      if current_user.only_could_revise?
        @serial.update_attribute(:is_applied, false)
      end
      @serial.update_attribute(:total_images,0)
      @serial.update_attribute( :user_id,current_user.id)
      redirect_to(serial_path(id:@serial.transliterated_link))
    else
      render 'new'
    end
  end

  def show
    @serial = Serial.includes(:reviews,
                              serial_elements: :element,
                              character_participates: [{character: :attachments}, {creator: :attachments}],
                              creator_participates: [:creator, :credit],song_participates: {song: {song_stuffs: [:creator,:credit]}})
                  .where(transliterated_link:params[:id])[0]
    @attachments = @serial.attachments.where(is_applied:true)
    @chapters = @serial.chapters.where(is_applied:true,is_cancelled:false).order('chapter_id desc')
    if @serial.blank?
      render('not_found/index',status:404) && return
    end
    @elements = Element.joins(:serial_elements).where("serial_id=#{@serial.id}").order(:elem_type,:title)
    @videos = Video.includes(:translator).where(serial_id:@serial.id,chapter_id:-1).order('video_date desc')
    @associated_serials = @serial.associated
    commontator_thread_show(@serial)
    Notification.where(correctable:@serial,user:current_user).update_all(shown:true) if user_signed_in?

    @seo_obj = @serial
  end

  def edit
  end

  def update
    allowed_elements = Element.select(:id).order(:id).map{|e|e.id}
    elements_params = params[:serial_elements].to_s.split(',').map(&:to_i).select{|id| allowed_elements.include?(id)}.uniq.sort

    songs_params = params[:serial_songs].to_s.split(',').map{|x| x.split('-').map(&:to_i)}.sort
    allowed_songs = Song.where(id:songs_params.map{|pair| pair[0]}).map(&:id)
    songs_params.select!{|pair| allowed_songs.include? pair[0]}

    characters_params = params[:serial_characters].to_s.split(',').map{|x| x.split('-').map(&:to_i)}.sort
    allowed_characters = Character.where(id:characters_params.map{|dataset| dataset[0]}).map(&:id)
    characters_params.select!{|dataset| allowed_characters.include? dataset[0]}
    allowed_creators = Creator.where(id:characters_params.map{|dataset| dataset[1]}).map(&:id)
    characters_params.select!{|dataset| allowed_creators.include? dataset[1]}

    creators_params = params[:serial_creators].to_s.split(',').map{|x| x.split('-').map(&:to_i)}.sort
    allowed_creators = Creator.where(id:creators_params.map{|dataset| dataset[0]}).map(&:id)
    creators_params.select!{|dataset| allowed_creators.include? dataset[0]}
    allowed_credits = Credit.where(id:creators_params.map{|dataset| dataset[1]}).map(&:id)
    creators_params.select!{|dataset| allowed_credits.include? dataset[1]}


    covers = params[:attachments].blank? ? [] : params[:attachments]['cover']
    update_result = @serial.process_save(current_user,serial_params.to_hash,elements_params,songs_params,characters_params,creators_params,covers)
    if update_result
      redirect_to(serial_path(@serial.clear_link),notice: update_result)
    else
      render action: 'edit'
    end
  end

  def toggle_hide_to_unregistered
    @serial.hide_to_unregistered = !@serial.hide_to_unregistered
    @serial.save
    redirect_to(serial_path(@serial.transliterated_link))
  end

  def translate

  end

  def rate
    @serial = Serial.find(params[:serial_id].to_i)
    current_user.rate @serial, params[:score].to_i
  end

  def characters
    @serial = Serial.includes(character_participates: [:character, :creator])
                  .where(transliterated_link:params[:id])[0]
    if @serial.blank?
      render('not_found/index',status:404) && return
    end
  end

  def creators
    @serial = Serial.includes(creator_participates: [:creator, :credit])
                  .where(transliterated_link:params[:id])[0]
    if @serial.blank?
      render('not_found/index',status:404) && return
    end
  end

  def songs
    @serial = Serial.includes(song_participates: {song: {song_stuffs: [:creator,:credit]}}).where(transliterated_link:params[:id])[0]
    if @serial.blank?
      render('not_found/index',status:404) && return
    end
    if @serial.song_participates.blank?
      redirect_to(serial_path(@serial.transliterated_link),notice:'OST не найден') && return
    end
  end

  private
  def set_serial
    @serial = Serial.includes(serial_elements: :element,
                              song_participates: {song: {song_stuffs: [:creator,:credit]}},
                              character_participates: [:character, :creator],
                              creator_participates: [:creator, :credit],
    ).find(params[:id])
  end

  def serial_params
    params[:serial][:transliterated_link] = filter_text_for_url(params[:serial][:transliterated_link].downcase)
    if params[:serial][:transliterated_link].blank?
      params[:serial][:transliterated_link] = transliterate params[:serial][:title]
    end
    params[:serial][:transliterated_link] = process_unique_field(Serial,:transliterated_link,params[:serial][:transliterated_link],params['_method']=='patch')
    params[:serial][:description] = cure_froala(params[:serial][:description])
    params.require(:serial).permit(:transliterated_link,:title, :english_title, :original_title, :aka, :description, :release, :full_length, :adult, attachments_attributes: [:id,:serial_id,:cover])
  end
end
