module GithubIssuesCli
  class Command::Push < Command

    def execute
      issue_number = get_issue_number
      target = get_source_branch(issue_number)
      if target.nil?
        target = 'origin/issue-' + issue_number
        git_repo = get_git_repo
        git_repo.lib.command_proxy('config', ['push.default', 'upstream'])
        git_repo.lib.command_proxy('branch', ["--set-upstream-to=#{target}"])
      end

      print 'Pushing code to '
      puts bold target
      get_git_repo.push
    end
  end
end
