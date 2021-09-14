# frozen_string_literal: true

require "extensions/float"

RSpec.describe Extensions::Float do
  before(:all) do
    Float.include Extensions::Float
  end

  it "should round up a float to .25" do
    expect(1.12.round_up_to_quarter).to eql(1.25)
  end

  it "should round up a float to .5" do
    expect(1.37.round_up_to_quarter).to eql(1.50)
  end

  it "should round up a float to .75" do
    expect(1.63.round_up_to_quarter).to eql(1.75)
  end

  it "should round up a float to .0" do
    expect(1.77.round_up_to_quarter).to eql(2.0)
  end

  it "should not round up round numbers" do
    expect(2.0.round_up_to_quarter).to eql(2.0)
  end
end
