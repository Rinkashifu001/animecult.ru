class Commontator::Subscription < ActiveRecord::Base
  belongs_to :subscriber, polymorphic: true
  belongs_to :thread, inverse_of: :subscriptions

  validates :thread, presence: true, uniqueness: { scope: [ :subscriber_type, :subscriber_id ] }

  def self.comment_created(comment)
    recipients = comment.thread.subscribers.reject { |sub| sub == comment.creator }
    return if recipients.empty?

    mail = Commontator::SubscriptionsMailer.comment_created(comment, recipients)
    mail.respond_to?(:deliver_later) ? mail.deliver_later : mail.deliver
  end

  def unread_comments(show_all)
    created_at = Commontator::Comment.arel_table[:created_at]
    thread.filtered_comments(show_all).where(created_at.gteq(updated_at))
  end
end

# == Schema Information
#
# Table name: commontator_subscriptions
#
#  id              :bigint           not null, primary key
#  subscriber_type :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  subscriber_id   :bigint           not null
#  thread_id       :bigint           not null
#
# Indexes
#
#  index_commontator_subscriptions_on_s_id_and_s_type_and_t_id  (subscriber_id,subscriber_type,thread_id) UNIQUE
#  index_commontator_subscriptions_on_thread_id                 (thread_id)
#
# Foreign Keys
#
#  fk_rails_...  (thread_id => commontator_threads.id) ON DELETE => cascade ON UPDATE => cascade
#
