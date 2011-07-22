require 'spec_helper'

describe 'CapistranoPayload::Request' do
  include CapistranoPayload
  
  it 'raises DeliveryError on failed request' do
    stub_request(:post, "http://localhost:4567/fail").
      with(:body => fixture('payload.form'), :headers => {'Content-Type'=>'application/x-www-form-urlencoded'}).
      to_return(:status => 404, :headers => {})
    
    p = Payload.new('deploy', 'Comment', PAYLOAD, :form)
    proc { p.deliver('http://localhost:4567/fail') }.
      should raise_error DeliveryError, "404 Resource Not Found"
  end
  
  it 'delivers a payload' do
    stub_request(:post, "http://foo.bar.com/payload").
      with(:body => fixture('payload.form'), :headers => {'Content-Type'=>'application/x-www-form-urlencoded'}).
      to_return(:status => 200, :headers => {})
    
    p = Payload.new('deploy', 'Comment', PAYLOAD, :form)
    p.deliver('http://foo.bar.com/payload')
  end
end
