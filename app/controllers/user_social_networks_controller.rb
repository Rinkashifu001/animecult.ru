# frozen_string_literal: true

class UserSocialNetworksController < ApplicationController
  def destroy
    current_user.social_networks.find_by(provider: params[:provider])&.destroy
    successfully(api: true, status: :no_content)
  end
end
