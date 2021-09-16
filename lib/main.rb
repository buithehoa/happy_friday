# frozen_string_literal: true

require 'matrix'
require_relative 'scheduler/branch_and_bound'
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
      scheduler = Scheduler::BranchAndBound.new(workload.estimated_effort, workload.timezone_offsets)
      schedule = scheduler.run
      file_path = CSVHandler.export_schedule(schedule, workload, @output_path)

      puts "Processing step count: #{scheduler.step_count}"
      puts "Exported file path: #{file_path}"

      file_path
    rescue Scheduler::SchedulingException => e
      puts "[#{e.class.name}] #{e.message}"
    end
  end

  private

  def workload
    @workload ||= CSVHandler.workload(@performance_csv, @tasks_csv, @teams_csv)
  end
end
