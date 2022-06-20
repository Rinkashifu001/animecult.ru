require 'model_lib'

class NewsController < ApplicationController
  include ShownNotificationable

  before_action :set_new, only: [:edit,:update,:destroy,:show]
  before_action :access_deny_if_not_a_user, only: [:edit, :update, :new, :create]
  before_action :access_deny_if_could_not_moderate, only: [:destroy]

  def show
    @notification_correctable = @new
    commontator_thread_show(@new)
  end

  def index
    per_page = 36
    allowed_params = params.permit(:page)
    @page = [1,allowed_params[:page].to_i].max
    @news = New.where(is_cancelled: false, is_applied: true).includes(:attachments).order('created_at desc').paginate(per_page:per_page,page:@page)
  end

  def new
    @new = New.new
  end

  def create
    @new = New.new(new_params)
    if @new.link.blank?
      @new.link = prepare_link(@new.title)
    end
    if @new.descr_short.blank?
      @new.descr_short = New.prepare_descr_short(@new.descr_full)
    end
    if @new.save
      unless params[:attachments].blank?
        params[:attachments]['cover'].each do |cover|
          @attachment = @new.attachments.create!(cover: cover, main_object: @new, is_applied: true, user: current_user)
        end
      end
      if current_user.only_could_revise?
        @new.update_attribute(:is_applied, false)
      end
      @new.update_attribute( :user_id,current_user.id)
      @new.process_attachment_from_descr(request,current_user,true)
      redirect_to(news_path(@new),notice: successfully_created_notice(@new))
    else
      render :new
    end
  end

  def edit
  end

  def update
    covers = params[:attachments].blank? ? [] : params[:attachments]['cover']
    update_result = Model.process_save(@new,current_user,new_params.to_hash,covers)
    if update_result
      @new.process_attachment_from_descr(request,current_user, false)
      redirect_to(news_path(@new),notice: update_result)
    else
      render :edit
    end
  end

  def destroy
    @new.destroy
    redirect_to(news_index_path)
  end

  private

  def new_params
    params[:new][:descr_full] = cure_froala(params[:new][:descr_full])
    params.require(:new).permit(:title,:link,:descr_short,:descr_full, attachments_attributes: [:id,:cover])
  end

  def set_new
    id = params[:id]
    if id.to_i.zero?
      raw = New.where(link:id)
      if raw.empty?
        redirect_to(root_path,notice:'Новость не найдена') && return
      end
      @new = raw[0]
    else
      @new = New.find(id)
    end
  end
end
