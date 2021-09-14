# frozen_string_literal: true

require_relative 'node'
require_relative 'effort'

class Scheduler
  attr_reader :step_count

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

    assignments
  end

  private

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
