# frozen_string_literal: true

require 'matrix'
require_relative 'scheduler'
require_relative 'csv_handler'

class Main
  def initialize(performance_csv, tasks_csv, teams_csv, output_path)
    @performance_csv = performance_csv
    @tasks_csv = tasks_csv
    @teams_csv = teams_csv
    @output_path = output_path
  end

  def run
    begin
      workload = CSVHandler.workload(@performance_csv, @tasks_csv, @teams_csv)

      puts workload.estimated_effort.to_a.map(&:inspect)
      puts "Timezone offsets: #{workload.timezone_offsets.inspect}"
    # rescue StandardError => error
    #   puts "[ERROR] #{error.message}"
    end

    scheduler = Scheduler.new(workload.estimated_effort, workload.timezone_offsets)
    schedule = scheduler.run

    puts "\nSchedule:"
    puts schedule.to_a.map(&:inspect)
    puts "Step count: #{scheduler.step_count}"

    puts CSVHandler.export_schedule(schedule, workload, @output_path)
  end
end
