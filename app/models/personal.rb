# frozen_string_literal: true

class Personal < ApplicationRecord
  class << self
    def first_by_code(code)
      includes(:serial).where(code: code).where(created_at: (Time.current - 24.hours)..Time.current).first
    end
  end

  belongs_to :serial

  def seo_title
    serial.blank? ? 'Смотреть онлайн на animecult.me' : "Смотреть онлайн аниме #{serial.title} серия #{chapter_id}"
  end
end

# == Schema Information
#
# Table name: personals
#
#  id         :bigint           not null, primary key
#  code       :string
#  created_at :integer
#  chapter_id :integer
#  serial_id  :integer
#
# Indexes
#
#  index_personals_on_code  (code)
#
