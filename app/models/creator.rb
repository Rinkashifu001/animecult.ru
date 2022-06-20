# frozen_string_literal: true

# TODO: need move to concern
require 'model_lib'

class Creator < ApplicationRecord
  NAME = 'Персонал'
  CREATORS_LIMIT = 3
  EDITABLE_FIELDS = {
    link: 'Ссылка',
    title: 'Оригинальное название',
    title_translated: 'Перевод названия',
    description: 'Описание'
  }.freeze
  MANUAL_TRANSLATED = {
    'Animation Work' => 'Студии:',
    'Original Work' => 'Авторы:',
    'Direction' => 'Режиссёры:'
  }.freeze

  acts_as_commontable dependent: :destroy

  belongs_to :user, optional: true

  has_many :creator_participates
  has_many :character_participates
  has_many :song_stuffs
  has_many :description_elements, as: :description
  has_many :attachments, as: :main_object
  has_many :revisions, as: :correctable

  validates :title, presence: true
  validates :link, uniqueness: { message: 'Значение атрибута "Ссылка" должно быть уникально: "%<value>s"' },
                   format: { with: %r{\A[_a-z0-9/]+\z},
                             message: 'Ссылка должна состоять из латинских букв, цифр и подчеркиваний: %<value>s' }

  def image_path
    path = "/images/creators_#{id}.jpg"
    path if File.exist?(File.join(Rails.root, 'public', path))
  end

  def seo_title
    result = [title]
    result << title_translated if title_translated.present? && title != title_translated
    result.join(' | ')
  end

  def seo_description
    result = ["В создании каких аниме участвовал #{title}"]
    result << "| #{title_translated}" if title_translated.present? && title != title_translated
    result << 'узнайте на АнимеКульт!'
    result.join(' ')
  end
end

# == Schema Information
#
# Table name: creators
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
#  index_creators_on_link  (link)
#
