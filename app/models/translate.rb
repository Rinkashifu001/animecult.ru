# frozen_string_literal: true

class Translate < ApplicationRecord
  belongs_to :serial

  validates :description, presence: true
end

# == Schema Information
#
# Table name: translates
#
#  id          :integer          not null, primary key
#  description :text
#  selected    :boolean
#  serial_id   :integer
#
