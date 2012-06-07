# encoding: UTF-8
require 'spec_helper'

describe Whitelabel do
  let(:path) { fixture_path("whitelabel.yml") }

  before(:each) do
    Whitelabel.labels = []
  end

  context "initialization" do
    it "should load from a file" do
      expect { Whitelabel.from_file(path) }.to change { Whitelabel.labels.size }.by(2)
    end
  end

  context "label" do
    before(:each) do
      Whitelabel.from_file(path)
    end

    it "should have two different labels" do
      Whitelabel.find_label('test')[:label_id].should eql('test')
      Whitelabel.find_label('uschi')[:label_id].should eql('uschi')
      Whitelabel.find_label('wrong').should be_nil
    end

    it "should work thread safe" do
      Whitelabel.label = :bla
      Thread.new { Whitelabel.label = nil }
      Whitelabel.label.should_not be_nil
    end

    it "should find a label for a pattern" do
      Whitelabel.label_for('uschi').should_not be_nil
      Whitelabel.label.name.should eql('Uschi Müller')
    end

    it "should not find a label for a missing pattern" do
      Whitelabel.label_for('').should be_nil
    end

    it "should enable a temporary label" do
      label = Whitelabel.label_for('uschi')
      Whitelabel.label.should eql(label)
      tmp = Whitelabel.find_label('test')
      Whitelabel.with_label(tmp) do
        Whitelabel.label.should eql(tmp)
      end
      Whitelabel.label.should eql(label)
    end

    context "with current label" do
      before(:each) do
        Whitelabel.label = Dummy.new('some_id', 'some_name')
      end

      it "should access a label property via []" do
        Whitelabel[:name].should eql('some_name')
      end
    end
  end
end
