# frozen_string_literal: true

class ChapterLink < ApplicationRecord
  NAME = 'Внешняя ссылка'
  DEFAULT_TITLE = 'Внешняя ссылка'
  ERROR_BLANK = 'Укажите ссылку для добавления'
  ERROR_NO_SPACE = 'Ссылка не должна содержать пробелов'
  ERROR_HTTPS = 'Ссылка должна начинаться с https://'
  MESSAGE_APPLIED = 'Внешняя ссылка добавлена'
  MESSAGE_NOT_APPLIED = 'Внешняя ссылка отправлена на модерацию'

  belongs_to :user, optional: true
  belongs_to :account, optional: true
  belongs_to :chapter
end

# == Schema Information
#
# Table name: chapter_links
#
#  id           :bigint           not null, primary key
#  is_applied   :boolean          default(FALSE)
#  is_cancelled :boolean          default(FALSE)
#  link         :string
#  title        :string
#  account_id   :bigint
#  chapter_id   :bigint
#  user_id      :bigint
#
# Indexes
#
#  index_chapter_links_on_account_id  (account_id)
#  index_chapter_links_on_chapter_id  (chapter_id)
#  index_chapter_links_on_user_id     (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
