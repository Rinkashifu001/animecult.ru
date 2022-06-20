class ImageElemController < ApplicationController

  def remove_image
    image_elem = ImageElem.find(params[:id])
    review = image_elem.review
    image_elem.destroy
    redirect_to edit_review_path(id:review.id)
  end
end
