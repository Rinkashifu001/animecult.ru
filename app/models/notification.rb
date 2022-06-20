# frozen_string_literal: true

class Notification < ApplicationRecord
  # include AssociationCacheCounterable

  after_commit do
    binding.pry
    # association_cache_counter(user, :active_notifications, dependency_flag: shown)
  end

  belongs_to :user
  belongs_to :account
  belongs_to :correctable, polymorphic: true
end

# == Schema Information
#
# Table name: notifications
#
#  id               :bigint           not null, primary key
#  correctable_type :string
#  shown            :boolean          default(FALSE)
#  title            :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  account_id       :integer
#  correctable_id   :integer
#  user_id          :bigint
#
# Indexes
#
#  index_notifications_on_account_id  (account_id)
#  index_notifications_on_user_id     (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
