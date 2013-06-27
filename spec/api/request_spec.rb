require 'spec_helper'

subject{API::Request.new.request}

describe API::Request do
  describe "#initialize" do
    it "returns xml builder" do
      subject.should be_instance_of(Builder::XmlMarkup)
    end
  end

  describe "informational" do
    describe "exchange courses" do
      it "returns NBU" do
        subject.exchange.should == "aa"
      end
    end
  end
end