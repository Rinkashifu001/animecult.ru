class NotFoundController < ApplicationController
  def index
    render 'index', status: 404
  end
end
