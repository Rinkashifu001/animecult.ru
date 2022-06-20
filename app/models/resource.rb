# frozen_string_literal: true

class Resource < ApplicationRecord
  belongs_to :serial
end

# == Schema Information
#
# Table name: resources
#
#  id        :bigint           not null, primary key
#  title     :string
#  value     :string
#  serial_id :bigint
#
# Indexes
#
#  index_resources_on_serial_id  (serial_id)
#
