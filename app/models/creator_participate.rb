# frozen_string_literal: true

class CreatorParticipate < ApplicationRecord
  belongs_to :serial
  belongs_to :creator
  belongs_to :credit

  def title
    "#{creator.title} (#{credit.title})"
  end
end

# == Schema Information
#
# Table name: creator_participates
#
#  id         :bigint           not null, primary key
#  creator_id :integer
#  credit_id  :integer
#  serial_id  :integer
#
# Indexes
#
#  index_creator_participates_on_creator_id  (creator_id)
#  index_creator_participates_on_credit_id   (credit_id)
#  index_creator_participates_on_serial_id   (serial_id)
#
