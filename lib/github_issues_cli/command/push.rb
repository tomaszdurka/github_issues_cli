module GithubIssuesCli
  class Command::Push < Command

    def execute
      git_repo = get_git_repo
      target = get_git_push_target
      remote, ref = target.split('/', 2)
      puts git_repo.lib.command_proxy('push', [remote, "#{git_repo.current_branch}:#{ref}"])
    end
  end
end
