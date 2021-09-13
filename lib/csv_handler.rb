# frozen_string_literal: true

require 'csv'
require_relative 'workload'

class CSVHandler
  class << self

    def export_schedule(schedule, workload, output_path)
      file_path = "#{output_path}/schedule-#{timestamp}.csv"

      CSV.open(file_path, 'wb') do |csv|
        csv << [ 'Team', 'Local Time', 'UTC Time', 'Task No' ]

        schedule.column_vectors.each_with_index do |value, index|
          team_index = value.to_a.index { |e| e > 0.0 }

          csv << [ workload.team_names[team_index], 'x', 'x', workload.task_ids[index]]
        end
      end

      # Handles the case when output_path includes a trailing forward slash
      file_path.gsub('//', '/')
    end

    def workload(performance_csv, tasks_csv, teams_csv)
      workload = Workload.new

      rows = []
      CSV.foreach(performance_csv, csv_options).map do |performance|
        workload.team_names << performance[:team]

        rows << CSV.foreach(tasks_csv, csv_options).map do |task|
          workload.task_ids << task[:task_id]
          team_effort(performance, task)
        end
      end

      workload.estimated_effort = Matrix.rows(rows)
      workload.timezone_offsets = timezone_offsets(teams_csv)
      workload
    end

    private

    TIMEZONE_PATTERN = /\A((\+|\-)?(\d)+)\s(\w+)\z/
    NUMBER_OF_HOURS_PATTERN = /\A(\d)+ hour(s)?\z/
    TIMESTAMP_FORMAT = '%Y%m%d-%H%M%S'

    def timestamp
      Time.now.strftime(TIMESTAMP_FORMAT)
    end

    def timezone_offsets(teams_csv)
      CSV.foreach(teams_csv, csv_options).map do |team|
        team[:timezone].match(TIMEZONE_PATTERN).captures.first.to_f
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
      time = time_str.match(NUMBER_OF_HOURS_PATTERN).captures.first.to_f
      performance = performance_str.to_f

      time / performance
    end
  end
end
