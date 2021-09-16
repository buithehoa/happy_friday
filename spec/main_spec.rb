# frozen_string_literal: true

require 'spec_helper'
require 'main'

RSpec.shared_examples "There are no feasible schedules." do
  it "should write a message to stdout" do
    message = "[Scheduler::SchedulingException] It's not feasible for teams to complete tasks on Friday.\n"
    expect { Main.new(*@params).run }.to output(message).to_stdout
  end
end

RSpec.describe Main do
  def schedule_and_export(params)
    @file_path = Main.new(*params).run
    @csv_string = CSV.read(@file_path, headers: true).to_csv unless @file_path.nil?
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
      expect(@csv_string).to include("Moscow,Fri 01:00 PM - Fri 07:00 PM,Fri 10:00 AM - Fri 04:00 PM,4\n")
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

    it_behaves_like "There are no feasible schedules."
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
      expect(@csv_string).to include("Fiji,Fri 09:00 AM - Sat 01:00 AM,Thu 09:00 PM - Fri 01:00 PM,3\n")
    end
  end

  context %(With 02_too_many_tasks:
    02_early_timezones includes a number of tasks that teams can't complete on time.) do

    before(:all) do
      @params = [
        'spec/fixtures/files/02_too_many_tasks/performance.csv',
        'spec/fixtures/files/02_too_many_tasks/tasks.csv',
        'spec/fixtures/files/02_too_many_tasks/teams.csv',
        '/tmp',
      ]
      schedule_and_export(@params)
    end

    it_behaves_like "There are no feasible schedules."
  end

  context %(With 03_redundant_teams:
    03_redundant_teams includes more teams than tasks) do

    before(:all) do
      @params = [
        'spec/fixtures/files/03_redundant_teams/performance.csv',
        'spec/fixtures/files/03_redundant_teams/tasks.csv',
        'spec/fixtures/files/03_redundant_teams/teams.csv',
        '/tmp',
      ]
      schedule_and_export(@params)
    end

    it "should create an optimal schedule" do
      expect(@csv_string).to include("Maldives,Fri 09:00 AM - Fri 05:30 PM,Fri 04:00 AM - Fri 12:30 PM,3\n")
      expect(@csv_string).to include("Azerbaijan,Fri 09:00 AM - Fri 05:00 PM,Fri 05:00 AM - Fri 01:00 PM,1\n")
      expect(@csv_string).to include("Moscow,Fri 09:00 AM - Fri 03:30 PM,Fri 06:00 AM - Fri 12:30 PM,2\n")
    end
  end

  context %(With 04_30_45_timezones:
    04_30_45_timezones includes teams in timezones with 30-minute and 45-minute offsets) do

    before(:all) do
      @params = [
        'spec/fixtures/files/04_30_45_timezones/performance.csv',
        'spec/fixtures/files/04_30_45_timezones/tasks.csv',
        'spec/fixtures/files/04_30_45_timezones/teams.csv',
        '/tmp',
      ]
      schedule_and_export(@params)
    end

    it "should create an optimal schedule" do
      expect(@csv_string).to include("Canada,Fri 09:00 AM - Fri 01:00 PM,Fri 11:30 AM - Fri 03:30 PM,1\n")
      expect(@csv_string).to include("Afghanistan,Fri 09:00 AM - Fri 03:00 PM,Fri 04:30 AM - Fri 10:30 AM,2\n")
      expect(@csv_string).to include("Nepal,Fri 09:00 AM - Fri 01:00 PM,Fri 03:15 AM - Fri 07:15 AM,3\n")
      expect(@csv_string).to include("Nepal,Fri 01:00 PM - Fri 07:00 PM,Fri 07:15 AM - Fri 01:15 PM,4\n")
    end
  end

end
