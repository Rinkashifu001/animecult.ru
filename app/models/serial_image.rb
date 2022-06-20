# frozen_string_literal: true

class SerialImage < ApplicationRecord
  belongs_to :serial
end

# == Schema Information
#
# Table name: serial_images
#
#  id           :integer          not null, primary key
#  frame        :boolean          default(FALSE)
#  image_number :integer
#  serial_id    :integer
#
# Indexes
#
#  idx_serial_image_serial  (serial_id)
#
