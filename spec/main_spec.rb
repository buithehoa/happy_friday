# frozen_string_literal: true

require 'spec_helper'
require 'main'

RSpec.describe Main do
  describe 'With sample_input' do
    before(:all) do
      @params = [
          'spec/fixtures/files/sample_input/performance.csv',
          'spec/fixtures/files/sample_input/tasks.csv',
          'spec/fixtures/files/sample_input/teams.csv',
          '/tmp',
        ]
      @file_path = Main.new(*@params).run
      @csv_string = CSV.read(@file_path, headers: true).to_csv
    end

    it "should write the exported file path to stdout" do
      expect { @tmp = Main.new(*@params).run }.to output(@tmp).to_stdout
    end

    it "should save exported file to the specified output path" do

      expect(@file_path).to include('/tmp')
      expect(File.exist?(@file_path)).to be_truthy
    end

    it "should include a header in the exported file" do
      expect(@csv_string).to include("Team,Local Time,UTC Time,Task No\n")
    end

    it "should create an optimal schedule" do
      expect(@csv_string).to include("Moscow,09:00 AM - 01:00 PM,06:00 AM - 10:00 AM,1\n")
      expect(@csv_string).to include("Moscow,10:00 AM - 04:00 PM,10:00 AM - 04:00 PM,4\n")
      expect(@csv_string).to include("London,09:00 AM - 02:00 PM,09:00 AM - 02:00 PM,2\n")
      expect(@csv_string).to include("London,02:00 PM - 06:00 PM,02:00 PM - 06:00 PM,3\n")
    end
  end
end
