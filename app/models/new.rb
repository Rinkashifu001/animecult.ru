# frozen_string_literal: true

class New < ApplicationRecord
  class << self
    def prepare_descr_short(text, max_length = 80)
      Nokogiri.HTML(text).xpath('//*/text()').map(&:text).join(' ')[0, max_length]
    end
  end

  NAME = 'Новость'
  EDITABLE_FIELDS = {
    link: 'Ссылка',
    title: 'Название',
    descr_short: 'Описание',
    descr_full: 'Текст статьи'
  }.freeze

  acts_as_commontable dependent: :destroy

  belongs_to :account, optional: true
  belongs_to :user, optional: true

  has_many :attachments, as: :main_object

  validates :title, presence: { message: 'Название новости не может быть пустым' }
  validates :link, uniqueness: { message: 'Значение атрибута "Ссылка" должно быть уникально: "%<value>s"' },
                   format: { with: %r{\A[_a-z0-9/]+\z},
                             message: 'Ссылка должна состоять из латинских букв, цифр и подчеркиваний: %<value>s' }

  def process_attachment_from_descr(request, user, trusted)
    src_raw = Nokogiri.HTML(descr_full).xpath('//img/@src')
    return if attachments.present? || src_raw.size.zero?

    is_applied = trusted || !user.only_could_revise?
    uri = ["http#{request.ssl? ? 's' : ''}://", request.domain, ':', request.port, src_raw.first&.text].join('')
    attachments.create!(main_object: self, is_applied: is_applied, user: user, remote_cover_url: uri)
  end
end

# == Schema Information
#
# Table name: news
#
#  id           :bigint           not null, primary key
#  descr_full   :string
#  descr_short  :string
#  is_applied   :boolean          default(TRUE)
#  is_cancelled :boolean          default(FALSE)
#  link         :string
#  title        :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  account_id   :integer
#  user_id      :bigint
#
# Indexes
#
#  index_news_on_account_id  (account_id)
#  index_news_on_user_id     (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
