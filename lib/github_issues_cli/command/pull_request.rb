module GithubIssuesCli
  class Command::Pull_request < Command

    parameter '[base]', 'base for pull-request', :attribute_name => :base, :default => 'master'

    def execute
      issue_number = get_issue_number
      raise "Pull-request for issue ##{issue_number} already exists" if get_pullrequest(issue_number)

      github_repo = get_upstream_repo
      git_repo = get_git_repo
      target = get_git_push_target
      remote, ref = target.split('/', 2)
      raise 'Pushing to upstream is not allowed. Check your git config.' if remote == 'upstream'
      puts git_repo.lib.command_proxy('push', [remote, "#{git_repo.current_branch}:#{ref}"])

      raise 'Cannot create pull-request for non-origin remotes' unless remote == 'origin'
      source = @username + ':' + ref.split('/').last
      begin
        request = {
          :user => github_repo[:user],
          :repo => github_repo[:name],
          :base => base,
          :head => source,
          :issue => issue_number
        }
        Github::PullRequests.new.create(request)
      rescue Exception => e
        raise "Internal error: Cannot create pull-request.\n#{e.inspect}"
      end
      print 'Pull request for issue '
      print bold '#' + issue_number
      puts ' created'
    end
  end
end
