# frozen_string_literal: true

class ImageElem < ApplicationRecord
  mount_uploaders :image, AvatarUploader

  belongs_to :review, optional: true
end

# == Schema Information
#
# Table name: image_elems
#
#  id        :bigint           not null, primary key
#  image     :json
#  review_id :bigint
#
# Indexes
#
#  index_image_elems_on_review_id  (review_id)
#
