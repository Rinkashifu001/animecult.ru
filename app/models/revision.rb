# frozen_string_literal: true

class Revision < ApplicationRecord
  CONTENT_TYPE_DEFAULT = 1
  CONTENT_TYPE_SERIAL_CHANGES = 1
  CONTENT_TYPE_SERIAL_ELEMENTS = 2
  CONTENT_TYPE_SERIAL_SONGS = 3
  CONTENT_TYPE_SERIAL_CHARACTERS = 4
  CONTENT_TYPE_SERIAL_CREATORS = 5
  CONTENT_TYPE_SONG_STUFFS = 2
  ALLOWED_ACTIONS = {
    do_apply: 'одобрение',
    undo_apply: 'отмена',
    do_cancel: 'блокировка',
    undo_cancel: 'разблокировка'
  }.freeze
  ALLOWED_TYPES = {
    serial: Serial,
    element: Element,
    chapter: Chapter,
    song: Song,
    character: Character,
    creator: Creator,
    review: Review,
    new: New,
    chapter_link: ChapterLink,
    video: Video
  }.freeze

  belongs_to :user
  belongs_to :correctable, polymorphic: true

  def title
    result = [user.present? ? "Правка от #{user.show_title}." : 'Автор правки не найден.']
    result <<
      if correctable.present?
        [correctable.class::NAME, correctable.title, '.'].reject(&:blank?).join(' ')
      else
        'Объект правки не найден.'
      end
    result
  end

  def do_apply
    return if correctable.nil?

    if correctable.is_a?(Serial)
      case content_type
      when Revision::CONTENT_TYPE_SERIAL_ELEMENTS
        SerialElement.where(serial_id: correctable_id, element_id: body['add'] + body['delete']).delete_all
        body['add'].each { |element_id| SerialElement.create(serial_id: correctable_id, element_id: element_id) }
        correctable.update_attribute(:elements_are_locked, true)
      when Revision::CONTENT_TYPE_SERIAL_SONGS
        correctable.song_participates.each do |sp|
          (body['add'] + body['delete']).each do |song_id, relation_id|
            sp.destroy if sp.song_id == song_id && sp.relation_id == relation_id
          end
        end
        body['add'].each do |song_id, relation_id|
          SongParticipate.create(serial_id: correctable_id, song_id: song_id, relation_id: relation_id)
        end
      when Revision::CONTENT_TYPE_SERIAL_CHARACTERS
        correctable.character_participates.each do |cp|
          (body['add'] + body['delete']).each do |character_id, creator_id, category|
            cp.destroy if cp.character_id == character_id && cp.creator_id == creator_id && cp.category == category
          end
        end
        body['add'].each do |character_id, creator_id, category|
          CharacterParticipate.create(serial_id: correctable_id, character_id: character_id,
                                      creator_id: creator_id, category: category)
        end
      when Revision::CONTENT_TYPE_SERIAL_CREATORS
        correctable.creator_participates.each do |cp|
          (body['add'] + body['delete']).each do |creator_id, credit_id|
            cp.destroy if cp.creator_id == creator_id && cp.credit_id == credit_id
          end
        end
        body['add'].each do |creator_id, credit_id|
          CreatorParticipate.create(serial_id: correctable_id, creator_id: creator_id, credit_id: credit_id)
        end
      else
        correctable.update_attribute(:is_locked, true)
      end
    elsif correctable.is_a?(Song) && content_type == Revision::CONTENT_TYPE_SONG_STUFFS
      correctable.song_stuffs.each do |ss|
        (body['add'] + body['delete']).each do |creator_id, credit_id|
          ss.destroy if ss.creator_id == creator_id && ss.credit_id == credit_id
        end
      end
      body['add'].each do |creator_id, credit_id|
        SongStuff.create(song_id: correctable_id, creator_id: creator_id, credit_id: credit_id)
      end
    else
      correctable.update(body)
    end
  end
end

# == Schema Information
#
# Table name: revisions
#
#  id               :bigint           not null, primary key
#  body             :json
#  content_type     :integer          default(1)
#  correctable_type :string
#  is_applied       :boolean          default(FALSE)
#  is_cancelled     :boolean          default(FALSE)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  correctable_id   :integer
#  user_id          :bigint
#
# Indexes
#
#  index_revisions_on_correctable_type_and_correctable_id  (correctable_type,correctable_id)
#  index_revisions_on_user_id                              (user_id)
#
