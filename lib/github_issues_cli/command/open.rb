module GithubIssuesCli
  class Command::Open < Command

    parameter 'summary', 'issue summary', :attribute_name => :summary

    def execute
      github_repo = get_upstream_repo
      issue = Github::Client::Issues.new.create :user => github_repo[:user], :repo => github_repo[:name], :title => summary
      issue_number = issue[:number].to_s

      get_upstream_repo
      git_repo = get_git_repo
      git_repo.remote('upstream').fetch
      remote_name = 'origin'
      branch_name = 'issue-' + issue_number

      git_repo.lib.command_proxy('checkout', ['-b', branch_name, 'upstream/master'])
      git_repo.lib.command_proxy('config', ["branch.#{branch_name}.remote", remote_name])
      git_repo.lib.command_proxy('config', ["branch.#{branch_name}.merge", "refs/heads/#{branch_name}"])

      print on_green ' '
      print ' Checked out '
      puts bold '#' + issue_number
    end
  end
end
