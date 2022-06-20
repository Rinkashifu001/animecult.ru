# frozen_string_literal: true

class SerialElement < ApplicationRecord
  belongs_to :serial
  belongs_to :element
end

# == Schema Information
#
# Table name: serial_elements
#
#  element_id :integer
#  serial_id  :integer
#
# Indexes
#
#  idx_se_element  (element_id)
#  idx_se_serial   (serial_id)
#
