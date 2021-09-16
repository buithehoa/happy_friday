# frozen_string_literal: true

require 'spec_helper'
require 'scheduler/timezone_helper'

RSpec.describe TimezoneHelper do
  include TimezoneHelper

  describe "#timezone_offset_str" do
    it "should return UTC with 0.0 as input" do
      expect(timezone_offset_str(0.0)).to eql('UTC')
    end

    it "should return +02:00 with 2.0 as input" do
      expect(timezone_offset_str(2.0)).to eql('+02:00')
    end

    it "should return +10:00 with 10.0 as input" do
      expect(timezone_offset_str(10.0)).to eql('+10:00')
    end

    it "should return -07:00 with -7.0 as input" do
      expect(timezone_offset_str(-7.0)).to eql('-07:00')
    end

    it "should return -02:30 with -2.5 as input" do
      expect(timezone_offset_str(-2.5)).to eql('-02:30')
    end

    it "should return +05:45 with 5.75 as input" do
      expect(timezone_offset_str(5.75)).to eql('+05:45')
    end
  end
end
