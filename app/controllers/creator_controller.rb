class CreatorController < ApplicationController

  before_action :access_deny_if_not_a_user, only: [:search]
  before_action :access_deny_if_not_a_user, only: [:edit, :update, :new, :create]
  before_action :set_creator, only: [:show, :edit, :update]

  def new
    @creator = Creator.new
  end

  def create
    @creator = Creator.new(creator_params)
    if @creator.save
      unless params[:attachments].blank?
        params[:attachments]['cover'].each do |cover|
          @attachment = @creator.attachments.create!(cover: cover, main_object: @creator, is_applied: true, user: current_user)
        end
      end
      if current_user.only_could_revise?
        @creator.update_attribute(:is_applied, false)
      end
      @creator.update_attribute( :user_id,current_user.id)
      redirect_to(creator_path(id:@creator.link))
    else
      render 'new'
    end
  end

  def edit

  end

  def update
    covers = params[:attachments].blank? ? [] : params[:attachments]['cover']

    update_result = Model.process_save(@creator,current_user,creator_params.to_hash,covers)
    if update_result
      redirect_to(creator_path(@creator.link),notice: update_result)
    else
      render action: 'edit'
    end

  end


  def show
    commontator_thread_show(@creator)
    Notification.where(correctable: @creator, user: current_user).update_all(shown:true) if user_signed_in?
  end

  def search
    key = russian_lower(remove_sql_explot(params[:q].to_s)).downcase
    result = []
    if key.size>=3
      result = Creator.where("lower(title) like '#{key}%' or lower(title_translated) like '#{key}%'").order(:title).limit(10).map{|e| {id: e.id,text: e.title}}
    end
    render json: result
  end

  private

  def creator_params
    params[:creator][:link] = filter_text_for_url(params[:creator][:link].downcase)
    if params[:creator][:link].blank?
      params[:creator][:link] = transliterate params[:creator][:title]
    end
    params[:creator][:link] = process_unique_field(Creator,:link,params[:creator][:link],params['_method']=='patch')
    params[:creator][:description] = cure_froala(params[:creator][:description])
    params.require(:creator).permit(:link,:title, :title_translated, :description, attachments_attributes: [:id,:creator_id,:cover])
  end

  def set_creator
    @creator = Creator.includes(creator_participates: [:serial, :credit],
                                character_participates: [:serial,:character],
                                song_stuffs: [:song,:credit],
                                description_elements: :tags).where(link:params[:id]).first
  end

end
