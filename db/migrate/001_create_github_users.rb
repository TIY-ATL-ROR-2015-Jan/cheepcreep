class CreateGithubUsers < ActiveRecord::Migration
  def self.up
    create_table :github_users do |t|
      t.string :login, uniqueness: true
      t.string :name
      t.string :blog
      t.integer :followers
      t.integer :following
      t.integer :public_repos
    end
  end

  def self.down
    drop_table :github_users
  end
end
