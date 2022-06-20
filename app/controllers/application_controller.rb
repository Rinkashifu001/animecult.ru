# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include ApplicationHelper

  protect_from_forgery with: :null_session
  before_action :fix_domain

  def access_deny_if_not_an_admin
    redirect_to_home_page unless permitted_access_scope(:admin)
  end

  def access_deny_if_not_a_user
    return if user_signed_in?

    redirect_to new_user_session_url
  end

  def access_deny_if_could_not_edit
    redirect_to_home_page unless permitted_access_scope(:admin, :moderator, :editor)
  end

  def access_deny_if_could_not_moderate
    redirect_to_home_page unless permitted_access_scope(:admin, :moderator)
  end

  private

  def fix_domain
    main_domain = Rails.env == 'production' ? SeoItem::MAIN_DOMAIN : 'localhost'
    protocol = Rails.env == 'production' ? 'https' : 'http'
    port = Rails.env == 'production' ? '' : ':3000'

    if request.domain!=main_domain && user_signed_in?
      sign_out(current_user)
    end

    if controller_name=='sessions' && request.domain!=main_domain
      redirect_to "#{protocol}://#{main_domain}#{port}#{request.fullpath}" #, status: :moved_permanently
    end
  end

  def permitted_access_scope(*access_scopes)
    return false unless user_signed_in?

    access_scopes.find { |access_scope| current_user.public_send("is_#{access_scope}?") }.present?
  end

  protected

  def redirect_to_home_page
    redirect_to root_path
  end

  def successfully(api: false, path: root_path, status: :ok, **options)
    if api
      render json: options.merge(status: 'success').to_json, status: status
    else
      redirect_to path, notice: notice
    end
  end

  def validation_failed(path: root_path, resource:, api: false)
    err_msg = resource.errors.messages.values.flatten.join(';')
    if api
      render json: { status: 'error', message: err_msg }, status: :ok
    else
      redirect_to path, notice: err_msg
    end
  end
end
