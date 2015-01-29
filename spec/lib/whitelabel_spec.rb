# encoding: UTF-8
require 'spec_helper'

describe Whitelabel do
  let(:path) { fixture_path("whitelabel.yml") }
  let(:dummy) { Dummy.new('some_id', 'some_name') }

  before(:each) do
    Whitelabel.labels = []
    Whitelabel.reset!
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

    it "finds two different labels" do
      expect(Whitelabel.find_label('test')[:label_id]).to eql('test')
      expect(Whitelabel.find_label('uschi')[:label_id]).to eql('uschi')
      expect(Whitelabel.find_label('wrong')).to be_nil
    end

    it "works thread safe" do
      Whitelabel.label = :bla
      Thread.new { Whitelabel.label = nil }
      expect(Whitelabel.label).to_not be_nil
    end

    it "finds a label for a pattern" do
      expect(Whitelabel.label_for('uschi')).to_not be_nil
      expect(Whitelabel.label.name).to eql('Uschi Müller')
    end

    it "does not find a label for a missing pattern" do
      expect(Whitelabel.label_for('')).to be_nil
    end

    it "enables a temporary label" do
      label = Whitelabel.label_for('uschi')
      expect(Whitelabel.label).to eql(label)
      tmp = Whitelabel.find_label('test')
      Whitelabel.with_label(tmp) do
        expect(Whitelabel.label).to eql(tmp)
      end
      expect(Whitelabel.label).to eql(label)
    end

    it "throws a meaningfull error when no label is set" do
      expect { Whitelabel[:blame] }.to raise_error("set a label before calling 'blame'")
    end

    context "each_label" do
      it "iterates all labels" do
        names = Whitelabel.each_label { Whitelabel[:name] }
        expect(names).to eql(["bla", "Uschi Müller"])
      end
    end

    context "with current label" do
      before(:each) do
        Whitelabel.label = dummy
      end

      context "resetting" do
        it "resets the current label" do
          expect(Whitelabel.label).to be(dummy)
          Whitelabel.reset!
          expect(Whitelabel.label).to be_nil
        end
      end

      context "accessing values" do
        it "accesses a label property via []" do
          expect(Whitelabel[:name]).to eql('some_name')
        end
      end
    end
  end
end
