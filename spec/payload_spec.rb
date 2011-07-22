require 'spec_helper'

describe 'CapistranoPayload::Payload' do
  include CapistranoPayload
  
  it 'raises ConfigurationError on invalid action' do
    proc { Payload.new('foo', '', {}) }.
      should raise_error ConfigurationError, "Invalid payload action: foo."
  end
  
  it 'raises ConfigurationError on invalid format' do
    proc { Payload.new('deploy', '', {}, :foo) }.
      should raise_error ConfigurationError, "Invalid payload format: foo."
  end
  
  it 'assigns data fields' do
    p = Payload.new('deploy', 'Comment', PAYLOAD)
    p.action.should == 'deploy'
    p.message.should == 'Comment'
  end
  
  it 'discards an invalid extra parameters container' do
    p = Payload.new('deploy', 'Comment', PAYLOAD, :json, 'Invalid params')
    p.params.should be_a Hash
    p.params.empty?.should == true
  end
  
  it 'deletes an invalid extra parameters' do
    p = Payload.new('deploy', 'Comment', PAYLOAD, :json, {'payload' => 'test', :payload => 'test', :api_key => 'test'})
    p.params.size.should == 1
    p.params.key?(:payload).should == false
    p.params.key?('payload').should == false
    p.params[:api_key].should == 'test'
  end
  
  it 'responds to format renderers' do
    p = Payload.new('deploy', 'Comment', PAYLOAD)
    Format::FORMAT_METHODS.each_pair do |f, method|
      p.respond_to?(method).should == true
    end
  end
end
