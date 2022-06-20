class ByYearController < ApplicationController
  def index
    serial_stat = SerialStat.first
    @years = (serial_stat.min_release..serial_stat.max_release).to_a.reverse
  end
end
