module AssociationCacheCounterable
  extend ActiveSupport::Concern

  included do
    association_cache_counter(:user, :active_notifications)
  end

  private

  def association_cache_counter(association, has_many_association)
    count_column_name = [has_many_association, 'count'].join('_').to_sym
    association.update_column(count_column_name, association.public_send(has_many_association).count)
  end
end
