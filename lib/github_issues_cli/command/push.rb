module GithubIssuesCli
  class Command::Push < Command

    def execute
      git_repo = get_git_repo
      issue_number = get_issue_number
      target = get_source_branch(issue_number)
      if target.nil?
        target = 'origin/issue-' + issue_number
        git_repo.lib.command_proxy('config', ['push.default', 'upstream'])
        git_repo.lib.command_proxy('push', ['--set-upstream'] + target.split('/'))
      end

      print 'Pushing code to '
      puts bold target
      git_repo.lib.command_proxy('push')
    end
  end
end
