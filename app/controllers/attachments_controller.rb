class AttachmentsController < ApplicationController

  before_action :access_deny_if_could_not_edit, only: [:destroy]

  def destroy
    @attachment = Attachment.find(params[:id])
    @attachment.destroy
    redirect_to request.referer
  end

end
