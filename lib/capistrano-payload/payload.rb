module CapistranoPayload
  class Payload
    include CapistranoPayload::Format
    include CapistranoPayload::Request
    
    # Allowed actions
    ACTIONS = ['deploy', 'rollback']
  
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
    # format  - Payload format (:json, :form). Default: json
    # params  - Extra parameters to payload (api_key, etc.), default: {}
    #           Could not contain 'capistrano' key. Will be removed if present.
    #           Should be a hash
    # 
    def initialize(action, message, data, format=:json, params={})
      @action  = action
      @message = message.strip
      @data    = data.merge(:action => @action, :message => @message)
      @format  = format.to_sym
      @params  = params.kind_of?(Hash) ? params : {}
      
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
        @params.delete('payload')
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
  end
end
