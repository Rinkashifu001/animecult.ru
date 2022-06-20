class ModerateController < ApplicationController

  before_action :access_deny_if_not_an_admin, only: [:appoint_editor,:appoint_moderator,:cancel_editor,:cancel_moderator]
  before_action :access_deny_if_could_not_moderate, except: [:upload_attachments_ajax]

  def objects
    object_type = params[:object_type].to_s.to_sym
    if Revision::ALLOWED_TYPES.include? object_type
      @object_type = object_type
      @objects =  Revision::ALLOWED_TYPES[object_type].includes(:account).where(is_applied: false)
      @include_cancelled = !!params[:include_cancelled]
      unless @include_cancelled
        @objects = @objects.where(is_cancelled:false)
      end
    end
  end

  def index
    @objects = {
        serial: Serial.where(is_applied: false,is_cancelled:false),
        element: Element.where(is_applied: false,is_cancelled:false),
        chapter: Chapter.where(is_applied: false,is_cancelled:false),
        song: Song.where(is_applied: false, is_cancelled: false),
        review: Review.where(is_applied: false,is_cancelled:false),
        new: New.where(is_applied: false,is_cancelled:false),
        chapterlink: ChapterLink.where(is_applied: false,is_cancelled:false),
        video: Video.where(is_applied: false,is_cancelled:false),
    }
    @revisions = Revision.where(is_applied:false,is_cancelled:false)
    @attachments = Attachment.where(is_applied: false)
  end

  def do_action
    allowed_params = params.permit(:action_type,:object_type,:object_id)
    action_type = allowed_params[:action_type].to_s.to_sym
    object_type = allowed_params[:object_type].to_s.downcase.to_sym
    object_id = allowed_params[:object_id].to_i
    if Revision::ALLOWED_TYPES.include? object_type
      begin
        object = Revision::ALLOWED_TYPES[object_type].find(object_id)
      rescue
        redirect_to(request.referer, notice: "Объект #{Revision::ALLOWED_TYPES[object_type]::NAME} ##{object_id} не найден") && return
      end
      if Revision::ALLOWED_ACTIONS.include? action_type
        case action_type
          when :do_apply
            object.update_attribute(:is_applied, true)
            # Notification.create(correctable:object,account:object.account,title:Notification::TITLE_OBJECT_APPLIED)
            Notifications::CreateService.call(correctable: object, title: :object_applied)
          when :undo_apply
            object.update_attribute(:is_applied, false)
          when :do_cancel
            object.update_attribute(:is_cancelled, true)
            Notifications::CreateService.call(correctable: object, title: :object_cancelled)
            # Notification.create(correctable:object,account:object.account,title:Notification::TITLE_OBJECT_CANCELLED)
          when :undo_cancel
            object.update_attribute(:is_cancelled, false)
        end
        redirect_to request.referer, notice: "Действие ##{Revision::ALLOWED_ACTIONS[action_type]} выполнено для объекта #{Revision::ALLOWED_TYPES[object_type]::NAME} ##{object.id}"
      else
        redirect_to request.referer, notice: 'Запрошенное действие отсутствует'
      end
    else
      redirect_to request.referer, notice: "Объект не найден по ключу '#{object_type}'"
    end
  end

  def revisions
    @revisions = Revision.includes(:user,:correctable).where(is_applied:false,is_cancelled:false).order(:id)
  end

  def images
    @attachments = Attachment.includes(:main_object, :user).where(is_applied: false)
  end

  def upload_attachments_ajax
    object_type = params[:object_type].to_s.to_sym
    object_id = params[:object_id].to_i
    i = 0
    is_applied = false
    result = []
    if user_signed_in? && Revision::ALLOWED_TYPES.include?(object_type)
      object = Revision::ALLOWED_TYPES[object_type].find(object_id)
      is_applied = !current_user.only_could_revise?
      loop do
        if params["file#{i}"].blank?
          break
        else
          attachment = Attachment.create(cover: params["file#{i}"], is_applied: is_applied, user: current_user, main_object: object)
          result << {src: attachment.cover_url, id: attachment.id}
        end
        i += 1
      end
    end
    render json: {allowed: is_applied ? 1 : 0, data: result}
  end

  def remove_attachment_ajax
    @attachment = Attachment.find(params[:id])
    @attachment.destroy
    render json: :ok
  end

  def remove_attachment
    @attachment = Attachment.find(params[:id])
    @attachment.destroy
    redirect_to request.referer, notice: 'Картинка удалена'
  end

  def apply_attachment
    attachment = Attachment.find(params[:id])
    attachment.update_attribute(:is_applied, true)
    redirect_to request.referer
  end

  def appoint_editor
    account = Account.find(params[:account_id])
    account.update_attribute(:is_editor,true)
    redirect_to request.referer, notice: "Аккаунт ##{account.id} назначен редактором"
  end

  def appoint_moderator
    account = Account.find(params[:account_id])
    account.update_attribute(:is_moderator,true)
    redirect_to request.referer, notice: "Аккаунт ##{account.id} назначен модератором"
  end

  def cancel_editor
    account = Account.find(params[:account_id])
    account.update_attribute(:is_editor,false)
    redirect_to request.referer, notice: "Аккаунт ##{account.id} больше не редактор"
  end

  def cancel_moderator
    account = Account.find(params[:account_id])
    account.update_attribute(:is_moderator,false)
    redirect_to request.referer, notice: "Аккаунт ##{account.id} больше не модератор"
  end

end
