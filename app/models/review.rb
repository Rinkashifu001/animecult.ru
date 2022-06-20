# frozen_string_literal: true

class Review < ApplicationRecord
  NAME = 'Рецензия'
  EDITABLE_FIELDS = {
    title: 'Название',
    descr_short: 'Описание',
    descr_full: 'Текст статьи'
  }.freeze

  acts_as_commontable dependent: :destroy

  belongs_to :serial
  belongs_to :account, optional: true
  belongs_to :user, optional: true

  has_many :image_elems
  has_many :attachments, as: :main_object

  validates :title, presence: { message: 'Название рецензии не может быть пустым' }

  def remove_images
    image_elems.map(&:destroy)
  end
end

# == Schema Information
#
# Table name: reviews
#
#  id           :bigint           not null, primary key
#  descr_full   :string
#  descr_short  :string
#  is_applied   :boolean          default(TRUE)
#  is_cancelled :boolean          default(FALSE)
#  title        :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  account_id   :integer
#  serial_id    :bigint
#  user_id      :bigint
#
# Indexes
#
#  index_reviews_on_account_id  (account_id)
#  index_reviews_on_serial_id   (serial_id)
#  index_reviews_on_user_id     (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
