# frozen_string_literal: true

class SongStuff < ApplicationRecord
  belongs_to :song
  belongs_to :creator
  belongs_to :credit
end

# == Schema Information
#
# Table name: song_stuffs
#
#  id         :bigint           not null, primary key
#  creator_id :integer
#  credit_id  :integer
#  song_id    :integer
#
# Indexes
#
#  index_song_stuffs_on_creator_id  (creator_id)
#  index_song_stuffs_on_credit_id   (credit_id)
#  index_song_stuffs_on_song_id     (song_id)
#
