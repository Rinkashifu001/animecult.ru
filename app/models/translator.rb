# frozen_string_literal: true

class Translator < ApplicationRecord
  has_many :videos
  has_and_belongs_to_many :serials

  def simple_link
    link.split('/')[-1]
  end
end

# == Schema Information
#
# Table name: translators
#
#  id    :integer          not null, primary key
#  link  :string(255)
#  title :string(255)
#
# Indexes
#
#  idx_translator_link  (link)
#
