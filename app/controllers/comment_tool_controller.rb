class CommentToolController < ApplicationController
  before_action :access_deny_if_not_an_admin

  def index
    @comments = Commontator::Comment.includes(:creator, thread: :commontable).order('updated_at desc')
  end
end
