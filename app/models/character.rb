# frozen_string_literal: true

# TODO: need move to concern
require 'model_lib'

class Character < ApplicationRecord
  NAME = 'Персонаж'
  EDITABLE_FIELDS = {
    link: 'Ссылка',
    title: 'Оригинальное название',
    title_translated: 'Перевод названия',
    description: 'Описание'
  }.freeze

  acts_as_commontable dependent: :destroy

  belongs_to :user, optional: true

  has_many :character_participates, dependent: :destroy
  has_many :description_elements, as: :description, dependent: :destroy
  has_many :attachments, as: :main_object, dependent: :destroy
  has_many :revisions, as: :correctable, dependent: :destroy

  validates :title, presence: true
  validates :link, uniqueness: { message: 'Значение атрибута "Ссылка" должно быть уникально: "%<value>s"' },
                   format: { with: %r{\A[_a-z0-9/]+\z},
                             message: 'Ссылка должна состоять из латинских букв, цифр и подчеркиваний: %<value>s' }

  def image_path
    path = "/images/characters_#{id}.jpg"
    path if File.exist? File.join(Rails.root, 'public', path)
  end

  def seo_title
    result = [title]
    result << "| #{title_translated}" if title_translated.present? && title != title_translated
    result.join(' ')
  end

  def seo_description
    result = "Аниме персонаж #{title}"
    result << "| #{title_translated}" if title_translated.present? && title != title_translated
    result << 'узнайте о нём всё на АнимеКульт!'
    result.join(' ')
  end
end

# == Schema Information
#
# Table name: characters
#
#  id               :bigint           not null, primary key
#  description      :string
#  is_applied       :boolean          default(TRUE)
#  is_cancelled     :boolean          default(FALSE)
#  link             :string
#  title            :string
#  title_translated :string
#  user_id          :integer
#
# Indexes
#
#  index_characters_on_link  (link)
#
