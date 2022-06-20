# frozen_string_literal: true

class DescriptionElement < ApplicationRecord
  belongs_to :description, polymorphic: true

  has_and_belongs_to_many :tags
end

# == Schema Information
#
# Table name: description_elements
#
#  id               :bigint           not null, primary key
#  descr            :string
#  description_type :string
#  title            :string
#  title_translated :string
#  description_id   :integer
#
