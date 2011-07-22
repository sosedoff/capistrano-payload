$:.unshift File.expand_path("../..", __FILE__)

require 'spec_utils'
require 'xmlsimple'
require 'webmock'
require 'webmock/rspec'
require 'capistrano-payload'

def fixture_path(file=nil)
  path = File.expand_path("../fixtures", __FILE__)
  path = File.join(path, file) unless file.nil?
  path
end

def fixture(file)
  File.read(File.join(fixture_path, file))
end

def json_fixture(file)
  MultiJson.decode(fixture(file))
end

def yaml_fixture(file)
  YAML.load(fixture(file))
end

def xml_fixture(file)
  hash = XmlSimple.xml_in(fixture(file), 'ForceArray' => false, 'KeepRoot' => false)
  hash.recursive_symbolize_keys!
  hash
end

def xml_fixture_from_string(data)
  hash = XmlSimple.xml_in(data, 'ForceArray' => false, 'KeepRoot' => false)
  hash.recursive_symbolize_keys!
  hash
end

PAYLOAD = {
  :version         => "2.6.0",
  :application     => "foobar",
  :deployer        => {
    :user          => "username",
    :hostname      => "localhost"
  },
  :timestamp       => Time.mktime(2011, 1, 1, 0, 0, 0),
  :source          => {
    :branch        => 'master',
    :revision      => 'abcdef',
    :repository    => 'git@github.com:username/repo.git'
  }
}