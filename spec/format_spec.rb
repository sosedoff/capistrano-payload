require 'spec_helper'

describe 'CapistranoPayload::Format' do
  include CapistranoPayload
  
  before :all do
    @payload = Payload.new('deploy', 'Comment', PAYLOAD)
  end

  it 'renders HASH' do
    data = @payload.to_hash
    data.key?(:capistrano).should == true
    data.key?(:payload_version).should == true
    data[:payload_version].should == CapistranoPayload::VERSION
  end

  it 'renders JSON' do
    @payload.to_json == json_fixture('payload.json')
  end
  
  it 'renders YAML' do
    @payload.to_yaml.should == fixture('payload.yml')
    @payload.to_hash.should == yaml_fixture('payload.yml')
  end
  
  it 'renders XML' do
    f = xml_fixture_from_string(@payload.to_xml)
    
    
    f.keys.should == xml_fixture('payload.xml').keys
    f.keys.should == @payload.to_hash.keys
    f[:capistrano].keys.should == xml_fixture('payload.xml')[:capistrano].keys
  end
end
