# frozen_string_literal: true

module Users
  module SocialNetworks
    class AuthService < BaseService
      private

      attr_reader :data, :current_user

      def pre_validate
        return if current_user.nil? || user_social_network.user.nil? || user_social_network.user != current_user

        add_custom_error('Данная учетная запись соц. сети закреплена за другим пользователем')
      end

      def user_social_network
        @user_social_network ||= UserSocialNetwork.find_or_initialize_by(provider: data.provider, uid: data.uid)
      end

      def execute
        user_social_network.user = build_user if user_social_network.user.nil?
        user_social_network.save! if user_social_network.changed?
      end

      def build_user
        email = data.info.email.presence || "#{data.uid}@#{data.provider}.com"
        nickname, _email_domen = email.split('@')
        User.new(email: email, nickname: nickname, password: Devise.friendly_token[0, 20])
      end

      def result_data
        super.merge(user: user_social_network.user) if valid?
      end
    end
  end
end
