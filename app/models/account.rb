# frozen_string_literal: true

class Account < ApplicationRecord
  has_many :users, dependent: :nullify
  has_many :notifications, dependent: :nullify
  has_many :news, class_name: 'New', dependent: :nullify
  has_many :chapters, dependent: :nullify
  has_many :chapter_links, dependent: :nullify
  has_many :elements, dependent: :nullify
  has_many :reviews, dependent: :nullify
  has_many :serials, dependent: :nullify
  has_many :videos, dependent: :nullify

  validates :nickname, uniqueness: { message: 'Такой никнейм уже существует: %<value>s' }, allow_blank: true

  def full_title
    result = ["account ##{id}"]
    result << nickname if nickname.present?
    result.join(' ')
  end

  def active_notifications
    return @active_notifications_count if @active_notifications_count.present?

    @active_notifications_count = notifications.where(shown: false).count
  end

  def standard_user
    users.where(provider: nil).first
  end
end

# == Schema Information
#
# Table name: accounts
#
#  id           :bigint           not null, primary key
#  is_admin     :boolean          default(FALSE)
#  is_editor    :boolean          default(FALSE)
#  is_moderator :boolean          default(FALSE)
#  nickname     :string
#
