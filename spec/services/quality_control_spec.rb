require 'spec_helper'

describe QualityControl do
  let(:throttle) { 0 }
  before(:each) do
    @user = FactoryGirl.create(:user)
    @sensor = @user.sensors.create(name: '1234abcd')
  end

  describe ".dedupe" do
    it "dedupes a users's readings" do
      10.times do
        FactoryGirl.create(
          :reading,
          sensor: @sensor,
          user: @user,
          temp: 45,
          outdoor_temp: 20,
          created_at: Time.now.to_i
        )
      end

      expect(@user.readings.count).to eq 10
      QualityControl.dedupe(@user)
      expect(@user.readings.count).to eq 1
    end
  end

  describe ".update_outdoor_temps_for" do
    before(:each) do
      sunday_afternoon = DateTime.parse("August 1, 2014 at 12pm")
      10.times do
        FactoryGirl.create(
          :reading,
          sensor: @sensor,
          user: @user,
          temp: 45,
          created_at: sunday_afternoon,
          outdoor_temp: nil,
        )
      end
    end

    it "updates missing outdoor temps", :vcr do
      partial_readings = @user.readings.where(outdoor_temp: nil)
      expect(partial_readings.count).to eq 10
      QualityControl.update_outdoor_temps_for(@user.readings, throttle, :silent)

      partial_readings = @user.readings.where(outdoor_temp: nil)
      expect(partial_readings.count).to eq 0
    end

    it "updates violation status", :vcr do
      violation_readings = @user.readings.where(violation: true)
      expect(violation_readings.count).to eq 10

      QualityControl.update_outdoor_temps_for(@user.readings, throttle, :silent)

      violation_readings = @user.readings.where(violation: true)
      expect(violation_readings.count).to eq 0
    end
  end
end
