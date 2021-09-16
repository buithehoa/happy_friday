# frozen_string_literal: true

require 'spec_helper'
require 'main'

RSpec.describe Main do
  def schedule_and_export(params)
    begin
      @file_path = Main.new(*params).run
      @csv_string = CSV.read(@file_path, headers: true).to_csv
    rescue; end;
  end

  context 'With sample_input' do
    before(:all) do
      @params = [
          'spec/fixtures/files/sample_input/performance.csv',
          'spec/fixtures/files/sample_input/tasks.csv',
          'spec/fixtures/files/sample_input/teams.csv',
          '/tmp',
        ]
      schedule_and_export(@params)
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
      expect(@csv_string).to include("Moscow,Fri 09:00 AM - Fri 01:00 PM,Fri 06:00 AM - Fri 10:00 AM,1\n")
      expect(@csv_string).to include("Moscow,Fri 10:00 AM - Fri 04:00 PM,Fri 10:00 AM - Fri 04:00 PM,4\n")
      expect(@csv_string).to include("London,Fri 09:00 AM - Fri 02:00 PM,Fri 09:00 AM - Fri 02:00 PM,2\n")
      expect(@csv_string).to include("London,Fri 02:00 PM - Fri 06:00 PM,Fri 02:00 PM - Fri 06:00 PM,3\n")
    end
  end

  # 00_late_timezones includes teams at late timezones.
  # With the specified values of effort required, the teams won't be able to complete all tasks on time.
  context %(With 00_late_timezones:
    00_late_timezones includes teams at late timezones.
    With the specified values of effort required, the teams won't be able to complete all the tasks on time.) do
    before(:all) do
      @params = [
        'spec/fixtures/files/00_late_timezones/performance.csv',
        'spec/fixtures/files/00_late_timezones/tasks.csv',
        'spec/fixtures/files/00_late_timezones/teams.csv',
        '/tmp',
      ]
      schedule_and_export(@params)
    end

    it "should write a message to stdout" do
      message = "[Scheduler::SchedulingException] It's not feasible for teams to complete tasks on Friday.\n"
      expect { Main.new(*@params).run }.to output(message).to_stdout
    end
  end

  context %(With 01_early_timezones:
    01_early_timezones includes teams at early timezones.
    Early timezones allow the teams to handle more work.) do

    before(:all) do
      @params = [
        'spec/fixtures/files/01_early_timezones/performance.csv',
        'spec/fixtures/files/01_early_timezones/tasks.csv',
        'spec/fixtures/files/01_early_timezones/teams.csv',
        '/tmp',
      ]
      schedule_and_export(@params)
    end

    it "should create an optimal schedule" do
      expect(@csv_string).to include("Papua New Guinea,Fri 09:00 AM - Sat 01:00 AM,Thu 11:00 PM - Fri 03:00 PM,1\n")
      expect(@csv_string).to include("Solomon Islands,Fri 09:00 AM - Sat 01:00 AM,Thu 10:00 PM - Fri 02:00 PM,2\n")
      expect(@csv_string).to include("Fiji,Fri 09:00 AM - Sat 01:00 AM,Thu 11:00 PM - Fri 03:00 PM,3\n")
    end
  end
end
