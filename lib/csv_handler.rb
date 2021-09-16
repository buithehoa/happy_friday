# frozen_string_literal: true

require 'csv'
require 'matrix'
require 'terminal-table'
require 'time'
require_relative 'extensions/float'
require_relative 'scheduler/timezone_helper'
require_relative 'scheduler/workload'

Float.include Extensions::Float

class CSVHandler
  class << self
    include TimezoneHelper

    def export_schedule(schedule, workload, output_path)
      file_path = "#{output_path}/schedule-#{timestamp}.csv"

      CSV.open(file_path, 'wb') do |csv|
        csv << ['Team', 'Local Time', 'UTC Time', 'Task No']

        schedule.row_vectors.each_with_index do |value, index|
          team_assignments(value, index, workload).each do |team_assignment|
             csv << team_assignment
          end
        end
      end

      file_path
    end

    # Returns a Workload object which encapsulates data specified in CSV input files.
    def workload(performance_csv, tasks_csv, teams_csv)
      workload = Scheduler::Workload.new

      rows = []
      CSV.foreach(performance_csv, csv_options).map do |performance|
        workload.team_names << performance[:team].strip
        rows << CSV.foreach(tasks_csv, csv_options).map do |task|
          team_effort(performance, task)
        end
      end

      workload.task_ids = task_ids(tasks_csv)
      workload.estimated_effort = Matrix.rows(rows)
      workload.timezone_offsets = timezone_offsets(teams_csv)
      workload
    end

    def pretty_print(file_path)
      rows = []
      CSV.foreach(file_path, headers: false, header_converters: :symbol) do |row|
        rows << row
      end
      puts Terminal::Table.new(rows: rows)
    end

    private

    TIMEZONE_PATTERN = /\A((\+|\-)?(\d)+)\s(\w+)\z/
    NUMBER_OF_HOURS_PATTERN = /\A(\d+|\d+\.\d+) hour(s)?\z/
    TIMESTAMP_FORMAT = '%Y%m%d-%H%M%S'
    WORKDAY_START_TIME = '2021-09-17 09:00' # Pick any Friday
    HOUR_IN_SECONDS = 3600
    TIME_FORMAT = '%a %I:%M %p'

    def task_ids(tasks_csv)
      CSV.foreach(tasks_csv, csv_options).map { |task| task[:task_id] }
    end

    def default_start_time(timezone_offset)
      Time.parse("#{WORKDAY_START_TIME} #{timezone_offset_str(timezone_offset)}")
    end

    # Return rows which represent scheduled tasks for the specified team.
    def team_assignments(team_tasks, team_id, workload)
      start_time = default_start_time(workload.timezone_offsets[team_id])

      team_tasks.each_with_index.map do |effort, task_index|
        next if effort == 0.0
        end_time = start_time + (effort.round_up_to_quarter * HOUR_IN_SECONDS)
        local_period = period_str(start_time, end_time)
        utc_period = period_str(start_time.utc, end_time.utc)
        start_time = end_time

        [ workload.team_names[team_id], local_period, utc_period, workload.task_ids[task_index] ]
      end.compact
    end

    def period_str(start_time, end_time)
      "#{start_time.strftime(TIME_FORMAT)} - #{end_time.strftime(TIME_FORMAT)}"
    end

    def timestamp
      Time.now.strftime(TIMESTAMP_FORMAT)
    end

    # Returns an array of timezone offsets pulled from input CSV file.
    def timezone_offsets(teams_csv)
      CSV.foreach(teams_csv, csv_options).map do |team|
        team[:timezone].strip.match(TIMEZONE_PATTERN).captures.first.to_i
      end
    end

    def csv_options
      { headers: true, header_converters: :symbol }
    end

    def team_effort(performance_row, task_row)
      developer_effort = engineer_effort(task_row[:development_time], performance_row[:developers])
      qa_effort = engineer_effort(task_row[:time_to_test], performance_row[:qa])

      developer_effort + qa_effort
    end

    def engineer_effort(time_str, performance_str)
      time = time_str.strip.match(NUMBER_OF_HOURS_PATTERN).captures.first.to_f
      performance = performance_str.to_f

      time / performance
    end
  end
end
