# frozen_string_literal: true

class SerialStat < ApplicationRecord
end

# == Schema Information
#
# Table name: serial_stats
#
#  id          :bigint           not null, primary key
#  max_release :integer
#  min_release :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
