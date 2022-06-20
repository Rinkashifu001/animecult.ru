# frozen_string_literal: true

class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  UserSocialNetwork::OMNIAUTH_PROVIDERS.each do |provider_name|
    define_method(provider_name) { provider_action }
  end

  def failure
    redirect_to root_path
  end

  private

  def provider_action
    result = Users::SocialNetworks::AuthService.call(data: provider_data, current_user: current_user)
    if result.valid?
      sign_in_and_redirect(result.data[:user], event: :authentication)
      set_flash_message(:notice, :success, kind: provider_data.provider) if is_navigational_format?
    else
      session["devise.#{provider_data.provider}_data"] = provider_data
      puts result.errors.to_a
      redirect_to new_user_registration_url
    end
  end

  def provider_data
    request.env['omniauth.auth']
  end
end
