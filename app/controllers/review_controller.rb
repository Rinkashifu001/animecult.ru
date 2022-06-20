require 'model_lib'

class ReviewController < ApplicationController
  before_action :set_review, only: [:edit,:update,:destroy,:show]
  before_action :access_deny_if_not_a_user, only: [:edit, :update, :new, :create]
  before_action :access_deny_if_could_not_moderate, only: [:destroy]

  def show
    commontator_thread_show(@review)
    Notification.where(correctable:@review,user:current_user).update_all(shown:true) if user_signed_in?
  end

  def index
    per_page = 36
    allowed_params = params.permit(:page)
    @page = [1,allowed_params[:page].to_i].max
    @reviews = Review.where(is_cancelled: false, is_applied: true).includes(:serial,:attachments).order('created_at desc').paginate(per_page:per_page,page:@page)
  end

  def new
    @review = Review.new
    @serial = Serial.find(params[:serial_id])
    @review.serial_id = @serial.id
  end

  def create
    @serial = Serial.find(review_params[:serial_id])
    @review = Review.new(review_params)
    if @review.save
      unless params[:attachments].blank?
        params[:attachments]['cover'].each do |cover|
          @attachment = @review.attachments.create!(cover: cover, main_object: @review, is_applied: true, user: current_user)
        end
      end
      if current_user.only_could_revise?
        @review.update_attribute(:is_applied, false)
      end
      @review.update_attribute( :user_id,current_user.id)
      redirect_to(review_path(@review))
    else
      render :new
    end
  end

  def edit
  end

  def update
    covers = params[:attachments].blank? ? [] : params[:attachments]['cover']
    update_result = Model.process_save(@review,current_user,review_params.to_hash,covers)
    if update_result
      redirect_to(review_path(@review),notice: update_result)
    else
      render :edit
    end
  end

  def destroy
    @review.destroy
    redirect_to(review_index_path)
  end

  def feed
    @reviews = Review.where(is_cancelled: false, is_applied: true).includes(:serial,:attachments).order('created_at desc')
    @news = New.where(is_cancelled: false, is_applied: true).includes(:attachments).order('created_at desc')
    render('feed',layout: false)
  end

  private
  def review_params
    params[:review][:descr_full] = cure_froala(params[:review][:descr_full])
    params.require(:review).permit(:title,:serial_id,:descr_short,:descr_full, attachments_attributes: [:id,:cover])
  end

  def set_review
    @review = Review.find(params[:id])
  end
end
