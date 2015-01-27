require "cheepcreep/version"
require "cheepcreep/init_db"
require "httparty"
require "pry"

module Cheepcreep
  class GithubUser < ActiveRecord::Base
    validates :login, presence: true
  end
end

class Github
  include HTTParty
  base_uri 'https://api.github.com'
  basic_auth ENV['GITHUB_USER'], ENV['GITHUB_PASS']

  def get_user(screen_name)
    result = self.class.get("/users/#{screen_name}")
    puts "#{result.headers['x-ratelimit-remaining']} requests left!"
    JSON.parse(result.body)
  end

  def get_user_endpoint(endpoint, screen_name, page=1, per_page=20)
    options = {:query => {:page => page, :per_page => per_page}}
    result = self.class.get("/users/#{screen_name}#{endpoint}", options)
    puts "#{result.headers['x-ratelimit-remaining']} requests left!"
    JSON.parse(result.body)
  end

  def get_followers(screen_name, page=1, per_page=20)
    get_user_endpoint('/followers', screen_name, page, per_page)
  end

  def get_gists(screen_name, page=1, per_page=20)
    get_user_endpoint('/gists', screen_name, page, per_page)
  end

  # def get_followers(screen_name, page=1, per_page=20)
  #   options = {:query => {:page => page, :per_page => per_page}}
  #   result = self.class.get("/users/#{screen_name}/followers", options)
  #   puts "#{result.headers['x-ratelimit-remaining']} requests left!"
  #   JSON.parse(result.body)
  # end

  # def get_gists(screen_name, page=1, per_page=20)
  #   options = {:query => {:page => page, :per_page => per_page}}
  #   result = self.class.get("/users/#{screen_name}/gists", options)
  #   puts "#{result.headers['x-ratelimit-remaining']} requests left!"
  #   JSON.parse(result.body)
  # end
end

def add_github_user(screen_name)
  user = github.get_user(screen_name)
  Cheepcreep::GithubUser.create(:login         => json['login'],
                                :name          => json['name'],
                                :blog          => json['blog'],
                                :followers     => json['followers'],
                                :following     => json['following'],
                                :public_repos  => json['public_repos'])
end

github = Github.new
add_github_user('redline6561')

followers = github.get_followers('redline6561', 1, 100)
followers.map { |x| x['login'] }.sample(20).each do |username|
  add_github_user(username)
end

binding.pry
