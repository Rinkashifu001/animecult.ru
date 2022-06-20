# frozen_string_literal: true

class UserSocialNetwork < ApplicationRecord
  OMNIAUTH_PROVIDERS = %i[vkontakte facebook google_oauth2 odnoklassniki mail_ru yandex].freeze

  belongs_to :user
end

# == Schema Information
#
# Table name: user_social_networks
#
#  id         :bigint           not null, primary key
#  provider   :string
#  uid        :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint
#
# Indexes
#
#  index_user_social_networks_on_provider_and_uid  (provider,uid)
#  index_user_social_networks_on_user_id           (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
