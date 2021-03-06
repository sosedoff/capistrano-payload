require 'capistrano'
require 'capistrano/version'
require 'socket'

module CapistranoPayload
  class CapistranoIntegration
    def self.load_into(capistrano_config)
      capistrano_config.load do  
        _cset(:payload_url) {
          abort 'Payload URL required! set :payload_url'
        }
        
        _cset(:payload_prompt)  { true }
        _cset(:payload_format)  { :json }
        _cset(:payload_params)  { Hash.new }
        
        _cset(:payload_data) {
          {
            :version         => Capistrano::Version.to_s.strip,
            :application     => fetch(:application),
            :deployer        => {
              :user          => ENV['USER'] || ENV['USERNAME'] || 'n/a',
              :hostname      => ENV['HOSTNAME'] || Socket.gethostname
            },
            :timestamp       => Time.now,
            :source          => {
              :branch        => fetch(:branch),
              :revision      => fetch(:real_revision),
              :repository    => fetch(:repository)
            }
          }
        }
      
        namespace :payload do
          task :deploy, :roles => :app do
            logger.debug("Sending deployment notification to #{fetch(:payload_url)}")
            message = payload_prompt == true ? Capistrano::CLI.ui.ask("Deployment message (none): ", nil) : ''
            begin
              CapistranoPayload::Payload.new('deploy', message, payload_data, payload_format, payload_params).deliver(payload_url)
            rescue DeliveryError => err
              logger.debug("Payload delivery error: #{err.message}")
            rescue ConfigurationError => err
              logger.debug("Payload configuration error: #{err.message}")
            end
          end
          
          task :rollback, :roles => :app do
            logger.debug("Sending rollback notification to #{fetch(:payload_url)}")
            message = payload_prompt == true ? Capistrano::CLI.ui.ask("Rollback message (none): ", nil) : ''
            begin
              CapistranoPayload::Payload.new('rollback', message, payload_data, payload_format, payload_params).deliver(payload_url)
            rescue DeliveryError => err
              logger.debug("Payload delivery error: #{err.message}")
            rescue ConfigurationError => err
              logger.debug("Payload configuration error: #{err.message}")
            end
          end
        end
        
        after :deploy,   'payload:deploy'
        after :rollback, 'payload:rollback'
      end
    end
  end
end

if Capistrano::Configuration.instance
  CapistranoPayload::CapistranoIntegration.load_into(Capistrano::Configuration.instance)
end