# frozen_string_literal: true

module Notifications
  class CreateService < BaseService
    private

    attr_reader :title, :correctable
    attr_writer :user

    def execute
      Notification.create(correctable: correctable, user: user,
                          title: I18n.t(title, scope: %i[notification titles], default: title))
    end

    def user
      @user ||= correctable.user
    end
  end
end
