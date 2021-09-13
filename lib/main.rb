# frozen_string_literal: true

require 'matrix'
require_relative 'scheduler'

class Main
  def initialize
    @available_hours = 15
  end

  def schedule
    estimated_effort = Matrix[
      [4,  4,  5, 6],
      [12, 12, 12, 16],
      [5, 5, 4, 6]
    ]
    timezone_offsets = [3, 2, 0]

    schedule = Scheduler.new(estimated_effort, timezone_offsets).run
    puts "\nTotal Effort: #{schedule.sum}"
    puts schedule.to_a.map(&:inspect)
  end

  private
end
