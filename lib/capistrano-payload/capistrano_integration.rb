require 'capistrano'

module CapistranoPayload
  class CapistranoIntegration
    def self.load_into(capistrano_config)
      capistrano_config.load do  
        _cset(:payload_url) {
          abort 'Payload URL required! set :payload_url'
        }
        
        _cset(:payload_format) { :json }
        
        _cset(:payload_data) {
          {
            :application     => fetch(:application),
            :deployer        => ENV['USER'] || ENV['USERNAME'] || 'n/a',
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
            begin
              CapistranoPayload::Payload.new('deploy', payload_data).deliver(fetch(:payload_url))
            rescue DeliveryError => err
              logger.debug("Payload delivery error: #{err.message}")
            end
          end
          
          task :rollback, :roles => :app do
            logger.debug("Sending rollback notification to #{fetch(:payload_url)}")
            begin
              CapistranoPayload::Payload.new('rollback', payload_data).deliver(fetch(:payload_url))
            rescue DeliveryError => err
              logger.debug("Payload delivery error: #{err.message}")
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