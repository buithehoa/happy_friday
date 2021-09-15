# frozen_string_literal: true

require 'spec_helper'
require 'scheduler/branch_and_bound'

RSpec.describe Scheduler::BranchAndBound do
  context "#run" do
    def run_scheduler(estimated_effort, timezone_offsets)
      @scheduler = Scheduler::BranchAndBound.new(estimated_effort, timezone_offsets)
      @schedule = @scheduler.run
    end

    describe 'sample_input' do
      before(:all) do
        estimated_effort = Matrix[
          [4,   4,  5,  6],
          [12,  12, 12, 16],
          [5,   5,  4,  6]
        ]
        timezone_offsets = [3, 2, 0]
        run_scheduler(estimated_effort, timezone_offsets)
      end

      it "should return an optimal schedule" do
        optimal_schedule = Matrix[
          [4, 0, 0, 6],
          [0, 0, 0, 0],
          [0, 5, 4, 0]
        ]

        expect(@schedule).to eql(optimal_schedule)
      end

      it "should return the number of processing steps" do
        expect(@scheduler.step_count).to be > 1
      end
    end

    describe "Same performance, same timezone " do
      before(:all) do
        estimated_effort = Matrix[
          [2,  4,  3,  6],
          [3,  6,  4,  2],
          [8,  6,  7,  6]
        ]
        timezone_offsets = [7, 7, 7]
        run_scheduler(estimated_effort, timezone_offsets)
      end

      it "should return an optional schedule" do
        optimal_schedule = Matrix[
          [2, 4, 0, 0],
          [0, 0, 4, 0],
          [0, 0, 0, 6]
        ]

        expect(@schedule).to eql(optimal_schedule)
      end
    end

    describe "Same performance, same timezone" do
      before(:all) do
        estimated_effort = Matrix[
          [2,  4,  3,  6],
          [3,  6,  4,  2],
          [8,  6,  7,  6]
        ]
        timezone_offsets = [7, 7, 7]
        run_scheduler(estimated_effort, timezone_offsets)
      end

      it "should return an optional schedule" do
        optimal_schedule = Matrix[
          [2, 4, 0, 0],
          [0, 0, 4, 0],
          [0, 0, 0, 6]
        ]

        expect(@schedule).to eql(optimal_schedule)
      end
    end
  end
end
