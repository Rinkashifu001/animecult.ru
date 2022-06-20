# frozen_string_literal: true

# TODO: need move to concern
require 'model_lib'

class Song < ApplicationRecord
  NAME = 'Песня'
  EDITABLE_FIELDS = {
    link: 'Ссылка',
    title: 'Оригинальное название',
    description: 'Описание'
  }.freeze

  acts_as_commontable dependent: :destroy

  has_many :song_participates
  has_many :song_stuffs
  has_many :description_elements, as: :description
  has_many :attachments, as: :main_object
  belongs_to :user, optional: true
  has_many :revisions, as: :correctable

  validates :title, presence: true
  validates :link, uniqueness: { message: 'Значение атрибута "Ссылка" должно быть уникально: "%<value>s"' },
                   format: { with: %r{\A[_a-z0-9/]+\z},
                             message: 'Ссылка должна состоять из латинских букв, цифр и подчеркиваний: %<value>s' }

  def song_type
    song_participate = song_participates.first
    if song_participate.blank?
      'OST'
    elsif song_participate.relation_id == SongParticipate::OPENING_ID
      'Опенинг'
    elsif song_participate.relation_id == SongParticipate::ENDING_ID
      'Эндинг'
    else
      'OST'
    end
  end

  def seo_title
    result = [title]
    ss = song_stuffs.first
    sp = song_participates.first
    result << "исполняет #{ss.creator.title}" if ss&.creator.present?
    if sp&.serial.present?
      result << "- #{song_type} аниме #{sp.serial.title}"
      result << "| #{sp.serial.english_title}" if sp.serial.english_title.present?
      result << "| #{sp.serial.original_title}" if sp.serial.original_title.present?
    end
    result.join(' ')
  end

  def seo_header
    ss = song_stuffs.first
    result = [title]
    result << "исполняет #{ss.creator.title}" if ss&.creator.present?
    result.join(' ')
  end

  def seo_description
    sp = song_participates.first
    ss = song_stuffs.first
    return "#{song_type} #{title}" if sp&.serial.nil?

    result = ["Какой #{song_type} у аниме #{sp.serial.title}"]
    result << "| #{sp.serial.english_title}" if sp.serial.english_title.present?
    result << "| #{sp.serial.original_title}" if sp.serial.original_title.present?
    result << "и кто его исполнял #{ss.creator.title}" if ss&.creator.present?
    result << '.'
    result.join(' ')
  end

  def process_save(user, params_hash, stuff_params, covers)
    changes = Model.changes_from_params(self, params_hash)
    stuff_current = song_stuffs.map { |ss| [ss.creator_id, ss.credit_id] }.sort
    return if changes.blank? && covers.blank? && stuff_current == stuff_params

    covers.each do |cover|
      attachments.create!(cover: cover, main_object: self, is_applied: !user.only_could_revise?, user: user)
    end
    if user.only_could_revise?
      if changes.present?
        assign_attributes(params_hash)
        return unless valid?

        Revision.create(user_id: user.id, body: changes, correctable: self)
      end
      if stuff_current != stuff_params
        stuff_to_delete = stuff_current - stuff_params
        stuff_to_add = stuff_params - stuff_current
        revision_body = { add: stuff_to_add, delete: stuff_to_delete }
        Revision.create(user_id: user.id, body: revision_body, correctable: self,
                        content_type: Revision::CONTENT_TYPE_SONG_STUFFS)
      end
      'Изменения будут проверены модератором'
    else
      return if changes.present? && !update(params_hash)

      if stuff_current == stuff_params
        SongStuff.where(song_id: id).delete_all
        stuff_params.each do |creator_id, credit_id|
          SongStuff.create(song_id: id, creator_id: creator_id, credit_id: credit_id)
        end
      end
      'Изменения были применены'
    end
  end
end

# == Schema Information
#
# Table name: songs
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
#  index_songs_on_link  (link)
#
