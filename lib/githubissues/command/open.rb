module GithubIssues
  class Command::Open < Command

    parameter "summary", "summary of the paramter", :attribute_name => :summary

    def execute
      github_repo = get_github_repo
      issues_client = Github::Issues.new :user => github_repo[:user], :repo => github_repo[:name]
      issue = issues_client.create :title => summary
      issue_number = issue[:number].to_s
      print on_green ' '
      print ' Created issue '
      puts bold '#' + issue_number

      git_repo = get_git_repo
      git_repo.branch('issue-' + issue_number).checkout
    end
  end
end