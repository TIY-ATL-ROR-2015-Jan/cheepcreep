require "cheepcreep/version"
require "cheepcreep/init_db"
require "httparty"
require "pry"

module Cheepcreep
end

class Github
  include HTTParty
  base_uri 'https://api.github.com'

  def initialize
    # ENV["FOO"] is like echo $FOO
    @auth = {:username => ENV['GITHUB_USER'], :password => ENV['GITHUB_PASS']}
  end

  def get_gists(screen_name)
    options = {:basic_auth => @auth}
    result = self.class.get("/users/#{screen_name}/gists", options)
    json = JSON.parse(result.body)
  end
end

binding.pry
