require 'rubygems'
require 'bundler'
require 'json'
Bundler.require

class App < Sinatra::Base
end

Dir.glob(["controllers/*.rb", "models/*.rb"]).each {
  |r| require_relative r
}

class App
  configure do
    set :app_file, __FILE__
    set :root, File.dirname(__FILE__)
    set :static, true
    set :public_folder, root + '/public'
    DataMapper.finalize
  end

  configure :test do
    set :show_exceptions, false
    DataMapper.setup(:default, 'sqlite::memory:')
    DataMapper::Logger.new(STDOUT, :debug)
    DataMapper.auto_migrate!
  end

  configure :development do
    enable :logging, :dump_errors, :raise_errors
    DataMapper.setup(:default, 'sqlite::memory:')
    DataMapper::Logger.new(STDOUT, :debug)
    DataMapper.auto_migrate!
  end

  before do
    content_type(:json)
  end

  helpers do
    def base_url
      "#{request.scheme}://#{request.host}"
    end

    def not_found
      [404, {error: "not found"}.to_json]
    end

    def clean_params
      params.delete("splat")
      params.delete("captures")
    end
  end

  get '/' do
    redirect "/index.html"
  end
end