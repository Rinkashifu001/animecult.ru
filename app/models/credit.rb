# frozen_string_literal: true

class Credit < ApplicationRecord
  has_many :song_stuffs
  has_many :creator_participates

  def show_title
    title_translated.present? ? title_translated : title
  end
end

# == Schema Information
#
# Table name: credits
#
#  id               :bigint           not null, primary key
#  title            :string
#  title_translated :string
#
