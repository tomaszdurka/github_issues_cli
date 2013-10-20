module GithubIssuesCli
  class Command::Open < Command

    parameter 'summary', 'issue summary', :attribute_name => :summary

    def execute
      github_repo = get_github_repo
      issue = Github::Issues.new.create :user => github_repo[:user], :repo => github_repo[:name], :title => summary
      issue_number = issue[:number].to_s

      get_github_repo
      git_repo = get_git_repo
      git_repo.remote('upstream').fetch
      git_repo.lib.checkout 'upstream/master', :new_branch => 'issue-' + issue_number
      print on_green ' '
      print ' Checked out '
      puts bold '#' + issue_number
    end
  end
end
