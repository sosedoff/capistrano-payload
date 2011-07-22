require 'rest-client'
require 'multi_json'

module CapistranoPayload
  class ConfigurationError < StandardError ; end
  class DeliveryError      < StandardError ; end
  
  class Payload
    include CapistranoPayload::Request
    
    # Allowed actions
    ACTIONS = ['deploy', 'rollback']
    
    # Allowed formats
    FORMATS = [:form, :json]
    
    # Method processing assignment
    FORMAT_METHODS = {
      :form => :to_hash,
      :json => :to_json
    }
    
    attr_reader :action
    attr_reader :message
    attr_reader :data
    attr_reader :format
    attr_reader :params
    
    # Initialize a new Payload object
    #
    # action  - Deployment action (deploy, rollback)
    # message - Deployment message (optional)
    # data    - Payload data
    # format  - Payload format (:json, :form)
    # params  - Extra parameters to payload (api_key, etc.), default: {}
    #           Could not contain 'capistrano' key. Will be removed if present.
    #           Should be a hash
    # 
    def initialize(action, message, data, format, params={})
      @action = action
      @data   = data.merge(:action => action, :message => message.strip)
      @format = format.to_sym
      @params = params.kind_of?(Hash) ? params : {}
      
      unless ACTIONS.include?(@action)
        raise ConfigurationError, "Invalid payload action: #{action}."
      end
      
      # Check if we have an invalid format
      unless FORMATS.include?(@format)
        raise ConfigurationError, "Invalid payload format: #{format}."
      end
      
      # Check if we have 'payload' keys (string or symbolic)
      unless @params.empty?
        @params.delete(:payload)
        @params.delete(:payload)
      end
    end
    
    # Performs payload delivery
    #
    #   url - Target url
    #
    def deliver(url)
      payload = self.send(FORMAT_METHODS[@format])
      begin
        request(:post, url, {:payload => payload}.merge(@params), format)
      rescue Exception => ex
        raise DeliveryError, ex.message
      end
    end
    
    protected
    
    # Returns a payload as hash
    #
    def to_hash
      payload = {
        :capistrano      => @data,
        :payload_version => CapistranoPayload::VERSION
      }
    end
    
    # Returns a payload as json
    def to_json
      MultiJson.encode(self.to_hash)
    end
  end
end
