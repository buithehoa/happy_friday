# frozen_string_literal: true

module Scheduler
  class Node
    attr_accessor :assignments
    attr_accessor :assigned_task_indices

    def initialize(assignments, assigned_task_indices)
      @assignments = assignments
      @assigned_task_indices = assigned_task_indices
    end

    def child_nodes(estimated_effort)
      estimated_effort.each_with_index.map do |value, team_index, task_index|
        unless @assigned_task_indices.include?(task_index)
          child_assignments = @assignments.dup
          child_assignments[team_index, task_index] = value
          child_assigned_task_indices = @assigned_task_indices.dup.append(task_index)

          Node.new(child_assignments, child_assigned_task_indices)
        end
      end.compact
    end

    def makespan(timezone_offsets)
      assignments.row_vectors.map(&:sum).each_with_index.map do |value, index|
        value - timezone_offsets[index]
      end.max
    end
  end
end
