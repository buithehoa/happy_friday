# frozen_string_literal: true

require_relative 'node'
require_relative 'effort'

class Scheduler
  def initialize(estimated_effort, timezone_offsets)
    @estimated_effort = estimated_effort
    @timezone_offsets = timezone_offsets

    @minimum_makespan = 0
  end

  def run
    stack = initialize_stack
    step_count = 0

    while not(stack.empty?)
      step_count += 1

      current_node = stack.pop
      current_node_makespan = current_node.makespan(@timezone_offsets)
      if current_node.assigned_task_indices.size == @estimated_effort.column_count
        if @minimum_makespan == 0 || current_node_makespan < @minimum_makespan
          @minimum_makespan = current_node_makespan

          assignments = current_node.assignments
        end
      else
        if @minimum_makespan == 0 || current_node_makespan < @minimum_makespan
          child_nodes = current_node.child_nodes(@estimated_effort)
          stack.push(*child_nodes)
        end
      end
    end

    puts "minimum_makespan = #{@minimum_makespan}"
    puts "step_count = #{step_count}"

    assignments
  end

  private

  def initialize_stack
    @estimated_effort.each_with_index.map do |value, team_index, task_index|
      assignments = empty_assignments
      assignments[team_index, task_index] = value

      effort = Effort.new(value, team_index, task_index)
      Node.new(effort, assignments, [ task_index ])
    end
  end

  def empty_assignments
    Matrix.zero(@estimated_effort.row_count, @estimated_effort.column_count)
  end

  def matrix_pretty_print(matrix)
    puts "\n"
    puts matrix.to_a.map(&:inspect)
  end
end
