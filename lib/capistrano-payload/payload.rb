require 'rest-client'
require 'multi_json'

module CapistranoPayload
  class DeliveryError < StandardError ; end
  
  class Payload
    attr_reader :action
    attr_reader :message
    attr_reader :data
    attr_reader :params
    
    # Initialize a new Payload object
    #
    # action  - Deployment action (deploy, rollback)
    # message - Deployment message (optional)
    # data    - Deployment parameters
    # params  - Extra parameters to payload (api_key, etc.), default: {}
    #           Could not contain 'capistrano' key. Will be removed if present.
    # 
    def initialize(action, message, data, params={})
      @action = action
      @data   = data.merge(:action => action, :message => message.strip)
      @params = params
      
      # Check if we have 'capistrano' keys (string or symbolic)
      unless @params.empty?
        @params.delete(:capistrano)
        @params.delete('capistrano')
      end
    end
    
    # Performs payload delivery
    #
    #   url - Target url
    #
    def deliver(url)
      payload = MultiJson.encode({:capistrano => @data}.merge(@params))
      begin
        RestClient.post(url, payload, :content_type => :json)
      rescue Exception => ex
        raise DeliveryError, ex.message
      end
    end
  end
end
