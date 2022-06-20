class TranslatesController < ApplicationController
  before_action :set_translate, only: [:show, :edit, :update, :destroy]
  before_action :set_serial, only: [:new]
  before_action :access_deny_if_not_an_admin, only: [:edit, :update, :destroy, :index]

  def index
    allowed_params = params.permit(:page)
    @page = [allowed_params[:page].to_i,1].max
    @translates = Translate.includes(:serial).where(selected:false).order(:serial_id).paginate(page:@page,per_page:10)
  end

  def show
    @serial = @translate.serial
  end

  def new
    @translate = Translate.new
  end

  def edit
    allow_params = params.permit(:serial_id,:page)
    @page = allow_params[:page]
    begin
      if allow_params.include?(:serial_id)
        @serial = Serial.find(allow_params[:serial_id])
      else
        @serial = Serial.find(@translate.serial_id)
      end
    rescue
    end
  end

  def create
    @translate = Translate.new(translate_params)
    @serial = Serial.find(params[:translate][:serial_id])
    @translate.serial_id = @serial.id
    if @translate.save
      redirect_to translate_path({id:@translate.id, serial_id:@serial.id}), notice: t('translates.new.translate_complete')
    else
      redirect_to new_translate_path(serial_id:@serial.id), notice: t('translates.new.translate_error')
    end
  end

  def update
    allow_params = params.require(:translate).permit(:description,:selected, :page, :serial_id)
    begin
      @page = allow_params[:page]
      @serial = Serial.find(allow_params[:serial_id])
      translates = @serial.translates
      serial_ok = translates.update_all(selected:false)
    rescue
      serial_ok = true
    end
    if serial_ok && @translate.update!(description:allow_params[:description],selected:allow_params[:selected])
      if @serial
        redirect_to translate_serial_path(@serial), notice: t('serial.translate.selected_true')
      else
        redirect_to translates_path(page:@page)
      end
    else
      if @serial
        redirect_to translate_serial_path(@serial), notice: t('serial.translate.selected_false')
      else
        redirect_to root_path
      end
    end
  end

  def destroy
    @translate.destroy
    redirect_to translates_path(page:params[:page]), notice: t('translates.index.deleted')
  end

  private
    def set_translate
      @translate = Translate.find(params[:id])
    end

    def translate_params
      params.require(:translate).permit(:description,:selected)
    end

  def set_serial
      @serial = Serial.find(params[:serial_id])
  end
end
