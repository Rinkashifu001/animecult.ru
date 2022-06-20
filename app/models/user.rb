# frozen_string_literal: true

class User < ApplicationRecord
  acts_as_commontator
  acts_as_favoritor
  searchkick
  devise :database_authenticatable, :registerable, :rememberable, :validatable, :omniauthable,
         omniauth_providers: UserSocialNetwork::OMNIAUTH_PROVIDERS

  after_commit :generate_nickname!, on: :create

  belongs_to :account

  has_many :social_networks, class_name: 'UserSocialNetwork', dependent: :destroy
  has_many :notifications, dependent: :destroy
  has_many :active_notifications, ->{ where(shown: false) }, class_name: 'Notification'
  has_many :attachments, dependent: :destroy
  # has_many :conversations, dependent: :destroy

  has_many :news, class_name: 'New', dependent: :nullify
  has_many :chapters, dependent: :nullify
  has_many :chapter_links, dependent: :nullify
  has_many :elements, dependent: :nullify
  has_many :reviews, dependent: :nullify
  has_many :serials, dependent: :nullify
  has_many :videos, dependent: :nullify

  validates :nickname, length: { in: 2..20, message: 'Никнейм должен быть от 2 до 20 символов' },
                       uniqueness: { message: 'Такой никнейм уже существует: %<value>' }, on: :update

  def self.find_first_by_auth_conditions(auth_params)
    login = auth_params[:email].to_s.strip
    where('LOWER(email) = :email OR nickname = :nickname', email: login.downcase, nickname: login).first
  end

  # TODO: need remove and/or move helper
  def show_title
    nickname
  end

  def only_could_revise?
    !is_admin? && !is_moderator? && !is_editor?
  end

  def moderation_available?
    is_admin? || is_moderator?
  end

  def create_account_if_not_exists
    if account.nil?
      create_account
      save(validate: false)
    end
    account
  end

  def provider_title
    return '' if provider.blank?

    email.split("-#{provider}").first
  end

  def generate_nickname(replace: false)
    self.nickname = "Nickname ##{id}" if nickname.blank? || replace
    self
  end

  def generate_nickname!(replace: false)
    generate_nickname(replace: replace)
    save(validate: false) if nickname_changed?
  end
end

# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  confirmation_sent_at   :datetime
#  confirmation_token     :string
#  confirmed_at           :datetime
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  is_admin               :boolean          default(FALSE)
#  is_editor              :boolean          default(FALSE)
#  is_moderator           :boolean          default(FALSE)
#  nickname               :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  unconfirmed_email      :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  account_id             :integer
#
# Indexes
#
#  index_users_on_account_id            (account_id)
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
