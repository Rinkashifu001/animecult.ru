class SongController < ApplicationController

  before_action :access_deny_if_not_a_user, only: [:search]
  before_action :access_deny_if_not_a_user, only: [:edit, :update, :new, :create]
  before_action :set_song, only: [:show, :edit, :update]

  def new
    @song = Song.new
  end

  def create
    @song = Song.new(song_params)
    if @song.save
      unless params[:attachments].blank?
        params[:attachments]['cover'].each do |cover|
          @attachment = @song.attachments.create!(cover: cover, main_object: @song, is_applied: true, user: current_user)
        end
      end
      if current_user.only_could_revise?
        @song.update_attribute(:is_applied, false)
      end
      @song.update_attribute( :user_id,current_user.id)
      redirect_to(song_path(id:@song.link))
    else
      render 'new'
    end
  end

  def edit

  end

  def update
    covers = params[:attachments].blank? ? [] : params[:attachments]['cover']

    stuff_params = params[:song_stuffs].to_s.split(',').map{|x| x.split('-').map(&:to_i)}.sort
    allowed_creators = Creator.where(id:stuff_params.map{|dataset| dataset[0]}).map(&:id)
    stuff_params.select!{|dataset| allowed_creators.include? dataset[0]}
    allowed_credits = Credit.where(id:stuff_params.map{|dataset| dataset[1]}).map(&:id)
    stuff_params.select!{|dataset| allowed_credits.include? dataset[1]}

    update_result = @song.process_save(current_user,song_params.to_hash,stuff_params,covers)
    if update_result
      redirect_to(song_path(@song.link),notice: update_result)
    else
      render action: 'edit'
    end

  end

  def show
    serials = {}
    @song.song_participates.each do |sp|
      serials[sp.relation_title] = [] unless serials.include? sp.relation_title
      serials[sp.relation_title] << {title:sp.serial.title,link:serial_path(sp.serial.transliterated_link)}
    end
    @serials = serials

    stuff = {}
    @song.song_stuffs.each do |ss|
      stuff[ss.credit.title_translated] = [] unless stuff.include? ss.credit.title_translated
      stuff[ss.credit.title_translated] << {title:ss.creator.title,link:creator_path(ss.creator.link)}
    end
    @stuff = stuff
    commontator_thread_show(@song)
    Notification.where(correctable:@song,user:current_user).update_all(shown:true) if user_signed_in?
  end

  def search
    key = russian_lower(remove_sql_explot(params[:q].to_s)).downcase
    result = []
    if key.size>=3
      result = Song.where("lower(title) like '#{key}%' or lower(title_translated) like '#{key}%'").order(:title).limit(10).map{|e| {id: e.id,text: e.title}}
    end
    render json: result
  end

  private

  def song_params
    params[:song][:link] = filter_text_for_url(params[:song][:link].downcase)
    if params[:song][:link].blank?
      params[:song][:link] = transliterate params[:song][:title]
    end
    params[:song][:link] = process_unique_field(Song,:link,params[:song][:link],params['_method']=='patch')
    params[:song][:description] = cure_froala(params[:song][:description])
    params.require(:song).permit(:link,:title, :description, attachments_attributes: [:id,:song_id,:cover])
  end

  def set_song
    @song = Song.includes(song_participates: [:serial], song_stuffs: [:creator, :credit]).where(link:params[:id]).first
  end

end
