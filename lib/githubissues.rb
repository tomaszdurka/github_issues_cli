module GithubIssues
  require 'clamp'
  require 'git'
  require 'term/ansicolor'
  require 'github_api'
  require 'githubissues/command'
  require 'githubissues/command/browse'
  require 'githubissues/command/show'
  require 'githubissues/command/open'
  require 'githubissues/command/checkout'
  require 'githubissues/command_manager'
end