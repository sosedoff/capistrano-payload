require 'rest-client'

module CapistranoPayload
  module Request
    TIMEOUT      = 4
    OPEN_TIMEOUT = 4
    
    CONTENT_TYPES = {
      :form => 'application/x-www-form-urlencoded',
      :json => 'application/json',
      :yaml => 'application/x-yaml',
      :xml  => 'application/xml'
    }.freeze
    
    # Performs a HTTP request
    #
    # method  - Request method (:get, :post, :put, :delete)
    # url     - Target URL
    # payload - Delivery content
    # format  - Delivery format
    #
    def request(method, url, payload, format)
      opts = {
        :method       => method,
        :url          => url,
        :payload      => payload,
        :headers      => {:content_type => CONTENT_TYPES[format]},
        :timeout      => TIMEOUT,
        :open_timeout => OPEN_TIMEOUT
      }
      
      RestClient::Request.execute(opts)
    end
  end
end
