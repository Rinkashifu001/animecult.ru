# frozen_string_literal: true

class SessionsController < Devise::SessionsController
  before_action :remember_redirect_url, only: :new

  private

  def remember_redirect_url
    return if request.referrer.nil? || request.referrer.include?(request.original_fullpath)

    session[:redirect_url] = request.referrer
  end

  def user_params
    resource_params.permit(:email, :password)
  end

  def after_sign_in_path_for(_user)
    redirect_url = session[:redirect_url]
    return account_index_path if redirect_url.blank?
    main_domain_level_one = 'org'
    domain_raw = request.domain.downcase.split('.')
    Rails.logger.info(redirect_url)
    if  domain_raw.size==2
      domain_name, domain_level_one = domain_raw
      %w[com me ru].each do |domain_level_one|
        redirect_url.gsub!("#{domain_name}.#{domain_level_one}","#{domain_name}.#{main_domain_level_one}")
      end
    end
    session[:redirect_url] = nil
    redirect_url
  end
end
