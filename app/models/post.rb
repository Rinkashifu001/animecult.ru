# frozen_string_literal: true

class Post < ApplicationRecord
  dragonfly_accessor :image
end

# == Schema Information
#
# Table name: posts
#
#  id         :integer          not null, primary key
#  body       :text
#  image_uid  :string(255)
#  img        :string(255)
#  title      :string(255)
#  created_at :datetime
#  updated_at :datetime
#
