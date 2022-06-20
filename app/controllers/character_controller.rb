class CharacterController < ApplicationController

  before_action :access_deny_if_not_a_user, only: [:search]
  before_action :access_deny_if_not_a_user, only: [:edit, :update, :new, :create]
  before_action :set_character, only: [:show, :edit, :update]

  def show
    @character = Character.includes(character_participates: [:serial, :creator], description_elements: :tags).where(link:params[:id]).first
    commontator_thread_show(@character)
    Notification.where(correctable: @character, user_id: current_user.id).update_all(shown:true) if user_signed_in?
  end

  def search
    key = russian_lower(remove_sql_explot(params[:q].to_s)).downcase
    result = []
    if key.size>=3
      result = Character.where("lower(title) like '#{key}%' or lower(title_translated) like '#{key}%'").order(:title).limit(10).map{|e| {id: e.id,text: e.title}}
    end
    render json: result
  end

  def new
    @character = Character.new
  end

  def create
    @character = Character.new(character_params)
    if @character.save
      unless params[:attachments].blank?
        params[:attachments]['cover'].each do |cover|
          @attachment = @character.attachments.create!(cover: cover, main_object: @character, is_applied: true, user: current_user)
        end
      end
      if current_user.only_could_revise?
        @character.update_attribute(:is_applied, false)
      end
      @character.update_attribute( :user_id,current_user.id)
      redirect_to(character_path(id:@character.link))
    else
      render 'new'
    end
  end

  def edit

  end

  def update
    covers = params[:attachments].blank? ? [] : params[:attachments]['cover']

    update_result = Model.process_save(@character,current_user,character_params.to_hash,covers)
    if update_result
      redirect_to(character_path(@character.link),notice: update_result)
    else
      render action: 'edit'
    end

  end

  private

  def character_params
    params[:character][:link] = filter_text_for_url(params[:character][:link].downcase)
    if params[:character][:link].blank?
      params[:character][:link] = transliterate params[:character][:title]
    end
    params[:character][:link] = process_unique_field(Character,:link,params[:character][:link],params['_method']=='patch')
    params[:character][:description] = cure_froala(params[:character][:description])
    params.require(:character).permit(:link,:title, :title_translated, :description, attachments_attributes: [:id,:character_id,:cover])
  end

  def set_character
    @character = Character.includes(character_participates: [:serial, :creator], description_elements: :tags).where(link:params[:id]).first
  end

end
