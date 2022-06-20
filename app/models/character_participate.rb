# frozen_string_literal: true

class CharacterParticipate < ApplicationRecord
  MAIN_CHARACTER_ID = 1
  SECONDARY_CHARACTER_ID = 2
  CATEGORY_TITLES = {
    MAIN_CHARACTER_ID => { single: 'Главный персонаж', many: 'Главные персонажи и их сэйю' },
    SECONDARY_CHARACTER_ID => { single: 'Второстепенный персонаж', many: 'Второстепенные персонажи и их сэйю' },
    3 => { single: 'Эпизодичный персонаж', many: 'Эпизодичные персонажи' },
    4 => { single: 'Камео', many: 'Камео' }
  }.freeze

  belongs_to :character
  belongs_to :serial
  belongs_to :creator

  def title
    "#{character.title} (#{[category_title, creator.title].reject(&:blank?).join(' - ')})"
  end

  def category_title
    CATEGORY_TITLES[category][:single]
  end

  def category_title_many
    CATEGORY_TITLES[category][:many]
  end
end

# == Schema Information
#
# Table name: character_participates
#
#  id           :bigint           not null, primary key
#  category     :integer
#  character_id :integer
#  creator_id   :integer
#  serial_id    :integer
#
# Indexes
#
#  index_character_participates_on_character_id  (character_id)
#  index_character_participates_on_creator_id    (creator_id)
#  index_character_participates_on_serial_id     (serial_id)
#
