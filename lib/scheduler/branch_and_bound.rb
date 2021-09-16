# frozen_string_literal: true

require 'matrix'
require_relative 'node'
require_relative 'scheduling_exception'
require_relative 'timezone_helper'

module Scheduler
  class BranchAndBound
    include TimezoneHelper

    attr_reader :step_count
    attr_reader :minimum_makespan

    def initialize(estimated_effort, timezone_offsets)
      @estimated_effort = estimated_effort
      @timezone_offsets = timezone_offsets
      @minimum_makespan = 0
    end

    def run
      stack = initialize_stack
      @step_count = 0

      while not(stack.empty?)
        current_node = stack.pop
        current_node_makespan = current_node.makespan(@timezone_offsets)

        # All tasks have been assigned
        if current_node.assigned_task_indices.size == @estimated_effort.column_count
          if @minimum_makespan == 0 || current_node_makespan < @minimum_makespan
            @minimum_makespan = current_node_makespan

            # Save the optimal assignments
            assignments = current_node.assignments
          end
        else
          # Continue with this path only if
          #   The minimum makespan hasn't been calculated or
          #   The current makespan is better than the minimum makespan
          if @minimum_makespan == 0 || current_node_makespan < @minimum_makespan
            child_nodes = current_node.child_nodes(@estimated_effort)
            stack.push(*child_nodes)
          end
        end

        @step_count += 1
      end

      verify_feasibility(assignments, @timezone_offsets)
    end

    private

    HOUR_IN_SECONDS = 3600
    WORKDAY_START_TIME = '09:00'

    # Returns true if tasks can be completed before midnight UTC.
    # Raises an exception when the tasks can't be completed on time.
    def verify_feasibility(assignments, timezone_offsets)
      if completed_on_time?(assignments, timezone_offsets)
        assignments
      else
        raise SchedulingException.new("It's not feasible for teams to complete tasks on Friday.")
      end
    end

    # Returns true if a team's tasks are done within the same day in UTC.
    def completed_on_time?(assignments, timezone_offsets)
      assignments.row_vectors.each_with_index.all? do |team_assignment, team_index|
        local_start_time = Time.parse("#{WORKDAY_START_TIME} #{timezone_offset_str(timezone_offsets[team_index])}")
        local_end_time = local_start_time

        team_assignment.each_with_index do |task_effort, task_index|
          next if task_effort == 0.0
          local_end_time = local_end_time + (task_effort * HOUR_IN_SECONDS)
        end

        local_start_time.wday === local_end_time.utc.wday
      end
    end

    def initialize_stack
      @estimated_effort.each_with_index.map do |value, team_index, task_index|
        assignments = empty_assignments
        assignments[team_index, task_index] = value

        Node.new(assignments, [ task_index ])
      end
    end

    def empty_assignments
      Matrix.zero(@estimated_effort.row_count, @estimated_effort.column_count)
    end
  end
end
