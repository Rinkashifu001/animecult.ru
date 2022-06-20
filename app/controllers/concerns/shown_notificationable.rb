# frozen_string_literal: true

module ShownNotificationable
  extend ActiveSupport::Concern

  included do
    attr_accessor :notification_correctable

    prepend_after_action :mark_notifications, only: :show
  end

  private

  def mark_notifications
    return unless notification_correctable.present? && user_signed_in?

    current_user.notifications.where(correctable: notification_correctable).update_all(shown: true)
  end
end
