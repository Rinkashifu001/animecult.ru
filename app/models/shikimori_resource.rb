# frozen_string_literal: true

class ShikimoriResource < ApplicationRecord
  belongs_to :serial
end

# == Schema Information
#
# Table name: shikimori_resources
#
#  id        :bigint           not null, primary key
#  title     :string
#  value     :string
#  serial_id :bigint
#
# Indexes
#
#  index_shikimori_resources_on_serial_id  (serial_id)
#
