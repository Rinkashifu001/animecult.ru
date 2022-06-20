class FavoriteController < ApplicationController

  before_action :access_deny_if_not_a_user, only: [:index]

  def index
    @favorite_scopes = {favorited: 'Избранное'}.update(Favorite::SCOPES)
    @favorites = Favorite.for_favoritor(current_user)
  end

  def toggle
    if user_signed_in?
      object_type = params[:object_type].to_s.to_sym
      object_id = params[:object_id].to_i
      scope = params[:scope].to_s.to_sym
      comment = params[:comment].to_s
      chapter_id = params[:chapter_id].to_i

      if Favorite::ALLOWED_TYPES.include? object_type
        begin
          object = Favorite::ALLOWED_TYPES[object_type].find(object_id)
        rescue
          render(plain: 'Object was not found') && return
        end
        data = Favorite.load_for_favoritor(current_user,object)
        favorite = nil
        if scope==:favorited
          if data.include?(:favorited)
            current_user.unfavorite(object,scope: :favorited)
          else
            favorite = current_user.favorite(object,scope: :favorited)
          end
        else
          current_user.unfavorite(object,scopes: data.keys.select{|s| Favorite::SCOPES.include?(s)})
          if Favorite::SCOPES.include? scope
            favorite = current_user.favorite(object, scope: scope)
          end
        end
        unless favorite.nil?
          favorite.title = comment
          favorite.chapter_id = chapter_id
          favorite.save
        end
        data = Favorite.load_for_favoritor(current_user,object)
        render partial: 'fragments/haml/favorite_dynamic', locals: {user: current_user, object: object,data: data}, layout: false
      else
        render plain: 'Wrong object type'
      end
    else
      render plain: 'User not found'
    end
  end

end
