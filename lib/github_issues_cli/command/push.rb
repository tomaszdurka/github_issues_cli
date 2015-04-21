module GithubIssuesCli
  class Command::Push < Command

    def execute
      issue_number = get_issue_number
      source = get_source_branch(issue_number)
      if source.nil?
        source = 'origin/issue-' + issue_number
      end
      print 'Pushing code to '
      puts bold source
      remote, branch = source.split('/')
      get_git_repo.push(remote, branch)
    end
  end
end
