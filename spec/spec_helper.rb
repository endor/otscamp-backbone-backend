ENV['RACK_ENV'] = 'test'
require_relative '../app'
require 'rspec'
require 'rack/test'

module TestHelpers
  def json_response
    JSON.parse(last_response.body)
  end

  def app
    App.new
  end
end

RSpec.configure do |conf|
  conf.include Rack::Test::Methods
  conf.include TestHelpers
  conf.before(:each) do
    DataMapper.auto_migrate!
  end
end
