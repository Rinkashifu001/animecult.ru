# frozen_string_literal: true

class Tag < ApplicationRecord
  has_and_belongs_to_many :description_elements

  def seo_title
    result = [title]
    result << "| #{title_translated}" if title_translated.present? && title != title_translated
    result.join(' ')
  end
end

# == Schema Information
#
# Table name: tags
#
#  id                     :bigint           not null, primary key
#  description            :string
#  description_translated :string
#  title                  :string
#  title_translated       :string
#
