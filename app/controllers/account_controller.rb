class AccountController < ApplicationController
  before_action :access_deny_if_not_a_user
  prepend_after_action :mark_notifications_as_shown, only: :index

  def index
    @user_social_networks = current_user.social_networks
    @notifications = current_user.notifications.order('created_at desc').limit(100)
  end

  def change_nickname
    current_user.nickname = params[:nickname].to_s.strip
    if current_user.save
      successfully(api: true, message: "Никнейм изменен: #{current_user.nickname}", value: current_user.nickname)
    else
      validation_failed(api: true, resource: current_user)
    end
  end

  def update_password
    current_user.password = params[:password]
    if current_user.save
      successfully(path: account_index_path, message: 'Пароль изменен')
    else
      validation_failed(path: account_index_path, resource: current_user)
    end
  end

  def notification_read
    notification_id = params[:notification_id].to_i
    notifications = current_user.notifications
    notifications = notifications.where(id: notification_id) if notification_id.positive?
    notifications.delete_all

    render plain: 'ok'
  end

  private

  def mark_notifications_as_shown
    current_user.notifications.update_all(shown: true) if current_user.active_notifications.size.positive?
  end
end
