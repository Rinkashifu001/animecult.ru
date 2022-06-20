# frozen_string_literal: true

class Chapter < ApplicationRecord
  NAME = 'Эпизод'
  MAX_CHAPTERS_WITHOUT_COLLAPSE = 26
  EDITABLE_FIELDS = {
    title: 'Название',
    chapter_id: 'Номер',
    description: 'Описание'
  }.freeze

  acts_as_commontable dependent: :destroy

  belongs_to :user, optional: true
  belongs_to :account, optional: true
  belongs_to :serial

  has_many :revisions, as: :correctable
  has_many :chapter_links
  has_many :videos

  validates :chapter_id, numericality: { only_integer: true, message: 'Номер серии должен быть целым числом' }
  validates :chapter_id, numericality: { greater_than: 0, message: 'Номер серии должен быть положительным числом' }
  validates :chapter_id,
            uniqueness: { scope: :serial_id,
                          message: 'Номер эпизода должен быть уникален в рамках произведения: "%<value>s"' }

  def seo_title
    "#{build_seo_text} онлайн с субтитрами или озвучкой"
  end

  def seo_h1
    result = [build_seo_first_text]
    result << "<a href='/serial/#{serial.transliterated_link}'>#{serial.title}</a>" if serial.title.present?
    result.join(' ').html_safe
  end

  def seo_description
    "#{build_seo_text} и узнайте где вы можете посмотреть его онлайн бесплатно с озвучкой или субтитрами."
  end

  def link_to_findanime
    "https://findanime.net/#{serial[:link]}/series#{chapter_id}"
  end

  def link_to_anime24
    "https://z.24animez.ru/serial/#{serial_id}/episode/#{chapter_id}"
  end

  # TODO: BEDA!!!, need refactoring and move to service or concern
  def process_save(user, params_hash)
    changes = {}
    params_hash.each_pair do |field, value|
      unless ([false, true].include?(send(field)) ? [false, true].index(send(field)) : send(field)).to_s == value
        changes[field] = value
      end
    end

    return if changes.blank?

    if user.moderation_available?
      return unless update(params_hash)

      'Изменения были применены'
    else
      assign_attributes(params_hash)
      return unless valid?

      Revision.create(user_id: user.id, body: changes, correctable: self)
      'Изменения будут проверены модератором'
    end
  end

  def show_title
    "#{serial.title} серия #{chapter_id}"
  end

  def _seo_title
    serial._seo_title
  end

  def _seo_length
    serial.full_length ? 'аниме фильм' : "#{chapter_id} серию аниме"
  end

  def _seo_link
    (serial.title.present? ? "<a href='/serial/#{serial.transliterated_link}'>#{serial.title}</a>" : '').html_safe
  end

  private

  def build_seo_first_text
    "Где смотреть #{serial.full_length ? 'аниме фильм' : "#{chapter_id} серию аниме"}"
  end

  def build_seo_text
    result = [build_seo_first_text]
    result << serial.title if serial.title.present?
    result << "| #{serial.english_title}" if serial.english_title.present? && serial.title != serial.english_title
    if serial.original_title.present? && serial.original_title != serial.english_title &&
       serial.original_title != serial.title
      result << "| #{serial.original_title}"
    end
    result.join(' ')
  end
end

# == Schema Information
#
# Table name: chapters
#
#  id           :bigint           not null, primary key
#  description  :string
#  is_applied   :boolean          default(TRUE)
#  is_cancelled :boolean          default(FALSE)
#  title        :string
#  user_title1  :string
#  user_title2  :string
#  account_id   :integer
#  chapter_id   :integer
#  serial_id    :bigint
#  user_id      :bigint
#
# Indexes
#
#  index_chapters_on_account_id  (account_id)
#  index_chapters_on_serial_id   (serial_id)
#  index_chapters_on_user_id     (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
