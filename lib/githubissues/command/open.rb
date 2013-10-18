module GithubIssues
  class Command::Open < Command

    parameter "summary", "summary of the paramter", :attribute_name => :summary

    def execute
      github_repo = get_github_repo
      issues = Github::Issues.new :user => github_repo[:user], :repo => github_repo[:name]
    end
  end
end
