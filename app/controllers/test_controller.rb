class TestController < ApplicationController

  before_action :access_deny_if_not_an_admin, only: [:index]

  def index

  end

  def ajax
    i = 0
    result = []
    loop do
      if params["file#{i}"].blank?
        break
      else
        cover = Attachment.create(cover: params["file#{i}"], is_applied: false, user: current_user)
        result << cover.cover_url
      end
      i += 1
    end
    render json: result
  end

  def yookassa
    Rails.logger.info(params)
    head :ok
  end

end
