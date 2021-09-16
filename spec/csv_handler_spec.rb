# frozen_string_literal: true

require 'spec_helper'
require 'csv_handler'

RSpec.describe CSVHandler do
  describe "#workload" do
    context "With sample_input" do
      before(:all) do
        params = [
          'spec/fixtures/files/sample_input/performance.csv',
          'spec/fixtures/files/sample_input/tasks.csv',
          'spec/fixtures/files/sample_input/teams.csv'
        ]
        @workload = CSVHandler.workload(*params)
      end

      it "should return estimated effort" do
        estimated_effort = Matrix[
          [4.0,   4.0,  5.0,  6.0],
          [12.0,  12.0, 12.0, 16.0],
          [5.0,   5.0,  4.0,  6.0]
        ]
        expect(@workload.estimated_effort).to eql(estimated_effort)
      end

      it "should return team names" do
        team_names = ['Moscow', 'Zagreb', 'London']
        expect(@workload.team_names).to eql(team_names)
      end

      it "should return task IDs" do
        task_ids = ['1', '2', '3', '4']
        expect(@workload.task_ids).to eql(task_ids)
      end

      it "should return timezone offsets" do
        timezone_offsets = [3.0, 2.0, 0.0]
        expect(@workload.timezone_offsets).to eql(timezone_offsets)
      end
    end
  end
end
