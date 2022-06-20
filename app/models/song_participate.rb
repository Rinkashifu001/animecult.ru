# frozen_string_literal: true

class SongParticipate < ApplicationRecord
  OPENING_ID = 1
  ENDING_ID = 2
  SONG_RELATIONS = {
    OPENING_ID => 'Openings | Опенинги',
    ENDING_ID => 'Endings | Эндинги',
    3 => 'Insert song',
    4 => 'Image song',
    5 => 'Background music',
    6 => 'Theme song'
  }.freeze

  belongs_to :song
  belongs_to :serial

  def title
    song.title
  end

  def relation_title
    SONG_RELATIONS[relation_id]
  end
end

# == Schema Information
#
# Table name: song_participates
#
#  id          :bigint           not null, primary key
#  relation_id :integer
#  serial_id   :integer
#  song_id     :integer
#
# Indexes
#
#  index_song_participates_on_serial_id  (serial_id)
#  index_song_participates_on_song_id    (song_id)
#
