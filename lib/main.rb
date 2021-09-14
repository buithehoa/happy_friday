# frozen_string_literal: true

require 'matrix'
require_relative 'scheduler'
require_relative 'csv_handler'

class Main
  def initialize(performance_csv, tasks_csv, teams_csv, output_path)
    @performance_csv = performance_csv
    @tasks_csv = tasks_csv
    @teams_csv = teams_csv
    @output_path = output_path.chomp('/')
  end

  def run
    begin
      workload = CSVHandler.workload(@performance_csv, @tasks_csv, @teams_csv)
      scheduler = Scheduler.new(workload.estimated_effort, workload.timezone_offsets)

      schedule = scheduler.run
      file_path = CSVHandler.export_schedule(schedule, workload, @output_path)

      puts "Processing step count: #{scheduler.step_count}"
      puts "Exported file path: #{file_path}"

    # rescue StandardError => error
    #   puts "[ERROR] #{error.message}"
    # TODO: Write backtrace to log files
    end

  end
end
