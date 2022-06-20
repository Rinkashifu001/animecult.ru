# frozen_string_literal: true

class Favorite < ApplicationRecord
  extend ActsAsFavoritor::FavoriteScopes

  class << self
    def load_for_favoritor(user, object)
      Favorite.for_favoritor(user).where(favoritable: object).each_with_object({}) { |f, hsh| hsh[f.scope.to_sym] = f }
    end
  end

  ALLOWED_TYPES = { serial: Serial }.freeze
  SCOPES = {
    planned: 'Запланировано',
    viewed: 'Просмотрено',
    abandoned: 'Брошено',
    deffered: 'Отложено',
    review: 'Пересматриваю',
    watch: 'Смотрю'
  }.freeze

  belongs_to :favoritable, polymorphic: true
  belongs_to :favoritor, polymorphic: true

  def block!
    update!(blocked: true)
  end
end

# == Schema Information
#
# Table name: favorites
#
#  id               :bigint           not null, primary key
#  blocked          :boolean          default(FALSE), not null
#  favoritable_type :string           not null
#  favoritor_type   :string           not null
#  scope            :string           default("favorite"), not null
#  title            :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  chapter_id       :integer
#  favoritable_id   :bigint           not null
#  favoritor_id     :bigint           not null
#
# Indexes
#
#  fk_favoritables                                         (favoritable_id,favoritable_type)
#  fk_favorites                                            (favoritor_id,favoritor_type)
#  index_favorites_on_blocked                              (blocked)
#  index_favorites_on_favoritable_type_and_favoritable_id  (favoritable_type,favoritable_id)
#  index_favorites_on_favoritor_type_and_favoritor_id      (favoritor_type,favoritor_id)
#  index_favorites_on_scope                                (scope)
#
