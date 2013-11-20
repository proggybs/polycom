require "spec_helper"
require "rexml/document"
require_relative "../lib/polycom/poller"

describe "Poller" do
  describe "#call_line_info" do
    before :each do
      @poller = Polycom::Poller.new(username: 'admin', password: '456', ip_address: '10.0.5.7')
    end
    it "should return an empty array" do
      @poller.should_receive(:fetch_xml).with("callstateHandler").and_return(REXML::Document.new)
      expect(@poller.call_line_info).to eq []
    end

    describe "with valid data" do
      before :each do
        xml_file = File.open("spec/data/call_line_info.xml")
        @poller.should_receive(:fetch_xml).with("callstateHandler").and_return(REXML::Document.new(xml_file.read))
        xml_file.close
      end

      it "should contain a hash for :each `CallLineInfo` element" do
        expect(@poller.call_line_info.count).to eq 1
      end

      it "should have correct fields populated in hash" do
        hash = @poller.call_line_info[0]

        expect(hash[:line_key_num]).to eq "1"
      end
    end
  end
end
