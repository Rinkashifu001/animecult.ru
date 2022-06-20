# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :authenticate_user!

  def search
    collection = []
    q = params[:q].to_s.strip
    users = User.search(q, fields: %w[nickname], limit: 30, load: false, misspellings: { below: 2 })
    collection = users.map { |user| user.slice(:id, :nickname) } if q.present?
    render json: collection.to_json, status: :ok
  end
end
