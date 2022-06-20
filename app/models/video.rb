# frozen_string_literal: true

class Video < ApplicationRecord
  NAME = 'Источник видео'
  LINK_WEBSITE = 'website'
  MESSAGE_APPLIED = 'Источник видео добавлен'
  MESSAGE_NOT_APPLIED = 'Источник видео отправлен на модерацию'
  DEFAULT_DETAILS = 'оригинал'
  DEFAULT_SOURCE = 'english'
  DETAILS_DATA = {
    'оригинал' => { details: %w[raw], details2: %w[Ориг. type9] },
    'озвучка' => { details: %w[dub], details2: %w[Озв. type12] },
    'сабы' => { details: %w[subs], details2: %w[Сабы type10] },
    'субтитры' => { details: %w[subs], details2: %w[Сабы type10] },
    'английские сабы' => { details: %w[eng_subs], details2: %w[EN-Саб type8] },
    'многоголосый' => { details: %w[many_dub], details2: %w[Мн.Озв. type11] },
    'озвучка+сабы' => { details: %w[dub subs], details2: %w[Оз+Саб type13] }
  }.freeze
  SOURCE_DATA = {
    'vk.com' => 'vk',
    'rutube.ru' => 'rutube',
    'sibnet.ru' => 'sibnet',
    'video.sibnet.ru' => 'sibnet',
    'myvi.tv' => 'myvi',
    'myvi.ru' => 'myvi',
    'myvi.top' => 'myvi',
    'kiwi.kz' => 'kiwi',
    'mail.ru' => 'mail',
    'videoapi.my.mail.ru' => 'mail',
    'animedia.tv' => 'animedia',
    'online.animedia.tv' => 'animedia',
    'hdgo.cc' => 'hdgo',
    'ok.ru' => 'ok',
    'openload.co' => 'openload',
    'rapidvideo.com' => 'rapidvideo',
    'smotret-anime.ru' => 'smotret_anime',
    'smotretanime.ru' => 'smotret_anime',
    'sovetromantica.com' => 'sovetromantica',
    'streamango.com' => 'streamango',
    'youtube.com' => 'youtube',
    'kg-portal.ru' => 'kg-portal'
  }.freeze

  belongs_to :account, optional: true
  belongs_to :user, optional: true
  belongs_to :serial
  belongs_to :chapter
  belongs_to :translator

  def source_image
    "#{SOURCE_DATA[source.gsub('www.', '')] || DEFAULT_SOURCE}.png"
  end

  def title
    "Видео: #{serial.blank? ? '' : serial.title} #{chapter_id.blank? ? '' : "серия #{chapter_id}"}".strip
  end
end

# == Schema Information
#
# Table name: videos
#
#  id            :integer          not null, primary key
#  details       :string(255)
#  is_applied    :boolean          default(TRUE)
#  is_cancelled  :boolean          default(FALSE)
#  link          :string(255)
#  source        :string(255)
#  stuff         :string(255)
#  video_date    :datetime
#  video_url     :string(4095)
#  account_id    :integer
#  chapter_id    :integer
#  serial_id     :integer
#  translator_id :integer
#  user_id       :bigint
#
# Indexes
#
#  idx_video_full              (serial_id,chapter_id)
#  idx_video_video_date        (video_date)
#  index_videos_on_account_id  (account_id)
#  index_videos_on_user_id     (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
