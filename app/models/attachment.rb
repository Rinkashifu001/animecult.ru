# frozen_string_literal: true

class Attachment < ApplicationRecord
  NAME = 'Картинка'
  ALLOWED_TYPES = {
    serial: Serial,
    song: Song,
    character: Character,
    creator: Creator,
    review: Review,
    new: New
  }.freeze

  mount_uploader :cover, CoverUploader

  belongs_to :user, optional: true
  belongs_to :main_object, polymorphic: true
end

# == Schema Information
#
# Table name: attachments
#
#  id               :bigint           not null, primary key
#  cover            :string
#  is_applied       :boolean          default(FALSE)
#  main_object_type :string
#  main_object_id   :integer
#  user_id          :bigint
#
# Indexes
#
#  index_attachments_on_user_id  (user_id)
#
