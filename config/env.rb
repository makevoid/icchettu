path = File.expand_path '../../', __FILE__
APP = "icchettu"

require "bundler/setup"
Bundler.require :default
module Utils
  def require_all(path)
    Dir.glob("#{path}/**/*.rb") do |model|
      require model
    end
  end
end
include Utils

env = ENV["RACK_ENV"] || "development"
password = File.read(File.expand_path "~/.password").strip

user = env == "production" ? "root:#{password}@" : ""
DataMapper.setup :default, "mysql://#{user}localhost/icchettu_#{env}"

require_all "#{path}/models"
DataMapper.finalize