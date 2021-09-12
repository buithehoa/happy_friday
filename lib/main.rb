# frozen_string_literal: true

require 'matrix'
require_relative 'greedy'

class Main
  MAXIMUM_ALLOWED_TEAM_EFFORT = 15

  def initialize
    @available_hours = 15
  end

  def schedule
    oat = Matrix[
      [4,   4,  5,  10],
      [12,  12,  12,  16],
      [5,   5,  4,  20]
    ]

    schedule = Greedy.new(oat, MAXIMUM_ALLOWED_TEAM_EFFORT).schedule
    puts "\nTotal Effort: #{schedule.sum}"
    puts schedule.to_a.map(&:inspect)
  end

  private
end
