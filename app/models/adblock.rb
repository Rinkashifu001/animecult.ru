# frozen_string_literal: true

class Adblock < ApplicationRecord
  class << self
    def allowed?(path)
      where(title: path).blank?
    end
  end

  validates :title, uniqueness: { message: 'Название должно быть уникально: "%<value>s"' },
                    format: { with: %r{\A/[_a-z0-9]+\z},
                              message: 'Путь должен быть частью ссылки и начинаться с "/": %<value>s' }
end

# == Schema Information
#
# Table name: adblocks
#
#  id    :bigint           not null, primary key
#  title :string
#
# Indexes
#
#  index_adblocks_on_title  (title)
#
