class UploadController < ApplicationController

  skip_before_action :verify_authenticity_token,only: [:upload_image]

  def upload_image
    options = {validation:{allowedExts:[".gif", ".jpeg", ".jpg", ".png", ".svg", ".blob", '.JPG','.JPEG','.PNG']}}
    f = FroalaEditorSDK::Image.upload(params,'public/uploads/images/',options)
    render json: f.gsub('/uploads/','/uploads/images/')
  end

end
