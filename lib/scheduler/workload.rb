# frozen_string_literal: true

module Scheduler
  class Workload
    attr_accessor :team_names
    attr_accessor :task_ids
    attr_accessor :estimated_effort
    attr_accessor :timezone_offsets

    def initialize
      @team_names = []
      @task_ids = []
      @timezone_offsets = []
    end
  end
end
