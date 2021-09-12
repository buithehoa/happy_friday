# frozen_string_literal: true

class Greedy
  attr_reader :effort_by_team
  attr_reader :maximum_allowed_team_effort
  attr_reader :pseudo_effort

  def initialize(effort_by_team, maximum_allowed_team_effort)
    @effort_by_team = effort_by_team.dup
    @maximum_allowed_team_effort = maximum_allowed_team_effort

    @pseudo_effort = effort_by_team.max + 1
  end

  def schedule
    assignments = empty_assignments

    while effort_by_team.min != pseudo_effort
      # min_effort[effort, team_index, task_index]
      min_effort = effort_by_team.each_with_index.min
      assignments[min_effort[1], min_effort[2]] = min_effort[0]
      effort_by_team.each_with_index do |effort, team_index, task_index|
        effort_by_team[team_index, task_index] = pseudo_effort if task_index == min_effort[2]
      end

      effort_when_assigned = current_assigned_effort(assignments, min_effort[1]) + min_effort[0]
      if effort_when_assigned > maximum_allowed_team_effort
        effort_by_team[min_effort[1], min_effort[2]] = pseudo_effort
      else
        assignments[min_effort[1], min_effort[2]] = min_effort[0]
        effort_by_team.each_with_index do |effort, team_index, task_index|
          effort_by_team[team_index, task_index] = pseudo_effort if task_index == min_effort[2]
        end
      end
    end

    validate_assignments(assignments)
  end

  private

  def validate_assignments(assignments)
    if assignments.column_vectors.any? { |task| task.zero? }
      empty_assignments
    else
      assignments
    end
  end

  def empty_assignments
    Matrix.zero(effort_by_team.row_count, effort_by_team.column_count)
  end

  def current_assigned_effort(assignments, team_index)
    assignments.row(team_index).sum
  end

  def matrix_pretty_print(matrix)
    puts "\n"
    puts matrix.to_a.map(&:inspect)
  end
end
