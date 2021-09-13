# frozen_string_literal: true

class Effort
  attr_accessor :value, :team_index, :task_index

  def initialize(value, team_index, task_index)
    @value = value
    @team_index = team_index
    @task_index = task_index
  end
end
