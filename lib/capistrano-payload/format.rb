require 'multi_json'
require 'yaml'
require 'builder'

module CapistranoPayload
  module Format
    # Allowed formats
    FORMATS = [:form, :json, :yaml, :xml]
    
    # Method processing assignment
    FORMAT_METHODS = {
      :form => :to_hash,
      :json => :to_json,
      :yaml => :to_yaml,
      :xml  => :to_xml
    }
    
    # Returns a payload as HASH
    #
    def to_hash
      payload = {
        :capistrano      => @data,
        :payload_version => CapistranoPayload::VERSION
      }
    end
    
    # Returns a payload as JSON
    #
    def to_json
      MultiJson.encode(self.to_hash)
    end
    
    # Returns a payload as YAML
    #
    def to_yaml
      YAML.dump(self.to_hash)
    end
    
    # Returns a payload as XML
    #
    def to_xml    
      xml = Builder::XmlMarkup.new(:indent => 2)
      xml.instruct!(:xml, :version => '1.0', :encoding => 'UTF-8')
      xml.capistrano do |c|
        c.action       @data[:action]
        c.message      @data[:message]
        c.version      @data[:version]
        c.application  @data[:application]
        c.deployer do |d|
          c.user       @data[:deployer][:user]
          c.hostname   @data[:deployer][:hostname]
        end
        c.timestamp    @data[:timestamp]
        c.source do |s|
          c.branch     @data[:source][:branch]
          c.revision   @data[:source][:revision]
          c.repository @data[:source][:repository]
        end
      end
      xml.payload_version(CapistranoPayload::VERSION).to_s
    end
  end
end
