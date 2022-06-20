# frozen_string_literal: true

class Element < ApplicationRecord
  NAME = 'Элемент произведения'
  GENRE_ID = 1
  CATEGORY_ID = 2
  DIRECTOR_ID = 3
  AUTHOR_ID = 4
  STUDIO_ID = 5
  ONGOING_ID = 7356
  AMV_ID = 10382
  OVA_ID = 7303
  EDITABLE_FIELDS = {
    title: 'Название',
    link: 'Ссылка',
    elem_type: 'Тип',
    description: 'Описание'
  }.freeze
  TITLES = {
    GENRE_ID => 'Жанры',
    CATEGORY_ID => 'Категории',
    DIRECTOR_ID => 'Режиссеры',
    AUTHOR_ID => 'Авторы',
    STUDIO_ID => 'Студии'
  }.freeze

  class << self
    def elem_title_by_category(category)
      {
        GENRE_ID => 'genre',
        CATEGORY_ID => 'category',
        DIRECTOR_ID => 'person',
        AUTHOR_ID => 'person',
        STUDIO_ID => 'studio'
      }[category]
    end
  end

  belongs_to :account, optional: true
  belongs_to :user, optional: true
  has_many :serial_elements
  has_many :revisions, as: :correctable

  validates :title, uniqueness: { scope: :elem_type, message: 'Элемент в рамках типа должен быть уникален' }
  validates :elem_type, inclusion: { in: [GENRE_ID, CATEGORY_ID, DIRECTOR_ID, AUTHOR_ID, STUDIO_ID],
                                     message: 'Наверно задан тип элемента' }
  validates :link,
            format: { with: %r{\A[_a-z0-9/]+\z},
                      message: 'Ссылка должна состоять из латинских букв, цифр и подчеркиваний: %<value>' },
            uniqueness: { scope: :elem_type,
                          message: 'Значение атрибута "Ссылка" в рамках типа должно быть уникально: "%<value>s"' }

  scope :by_elem_type, lambda { |elem_type|
    where(elem_type: elem_type, is_cancelled: false, is_applied: true).order(title: :asc)
  }

  def element_link
    link.split('/')[-1]
  end

  def type_title
    TITLES[elem_type]
  end

  def process_save(user,params_hash)
    changes = {}
    params_hash.each_pair do |field,value|
      next if ([false, true].include?(send(field)) ? [false, true].index(send(field)) : send(field)).to_s == value

      changes[field] = value
    end

    return if changes.blank?

    if user.moderation_available?
      'Изменения были применены' if update(params_hash)
    else
      assign_attributes(params_hash)
      if valid?
        Revision.create(user_id: user.id, body: changes, correctable: self)
        'Изменения будут проверены модератором'
      end
    end
  end
end

# == Schema Information
#
# Table name: elements
#
#  id           :integer          not null, primary key
#  description  :string(4095)
#  elem_type    :integer
#  is_applied   :boolean          default(TRUE)
#  is_cancelled :boolean          default(FALSE)
#  link         :string(255)
#  title        :string(255)
#  account_id   :integer
#  user_id      :bigint
#
# Indexes
#
#  index_elements_on_account_id  (account_id)
#  index_elements_on_user_id     (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
