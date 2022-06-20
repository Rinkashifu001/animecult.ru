class ElementController < ApplicationController
  before_action :access_deny_if_not_a_user, only: [:edit, :update, :new, :create]
  before_action :set_element, only: [:edit, :update]

  def new
    @element = Element.new
  end

  def create
    @element = Element.new(element_params)
    if @element.save
      unless current_user.moderation_available?
        @element.update_attribute(:is_applied, false)
      end
      @element.update_attribute( :user_id, current_user.id)
      redirect_to(set_path(@element))
    else
      render 'new'
    end

  end

  def edit
    @path = set_path(@element)
  end

  def update
    update_result = @element.process_save(current_user,element_params.to_hash)
    if update_result
      redirect_to(set_path(@element),notice: update_result)
    else
      render action: 'edit'
    end
  end

  def search
    key = russian_lower(remove_sql_explot(params[:q].to_s)).downcase
    result = []
    if key.size>=3
      result = Element.where(is_cancelled: false).where("lower(title) like '#{key}%'").order(:title).limit(10).map{|e| {id: e.id,text: "#{e.title} (#{e.type_title})#{e.is_applied ? '' : ' - не подтвержден модератором'}",elem_type:e.elem_type,value:e.title}}
    end
    render json: result
  end

  private
  def set_element
    @element = Element.find(params[:id])
  end

  def element_params
    params[:element][:link] = filter_text_for_url(params[:element][:link].downcase)
    if params[:element][:link].blank?
      params[:element][:link] = transliterate params[:element][:title]
    end
    params[:element][:description] = cure_froala(params[:element][:description])
    params.require(:element).permit(:title, :link, :description, :elem_type)
  end

end
