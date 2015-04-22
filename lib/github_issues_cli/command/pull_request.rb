module GithubIssuesCli
  class Command::Pull_request < Command

    parameter '[base]', 'base for pull-request', :attribute_name => :base, :default => 'master'

    def execute
      issue_number = get_issue_number
      raise 'Pull-request for issue #' + issue_number + ' already exists' if get_pullrequest(issue_number)

      github_repo = get_upstream_repo
      source = @username + ':issue-' + issue_number
      begin
        request = {
          :user => github_repo[:user],
          :repo => github_repo[:name],
          :head => source,
          :base => base,
          :issue => issue_number
        }
        Github::PullRequests.new.create request
      rescue Exception => e
        raise "Internal error: Cannot create pull-request.\n#{e.inspect}"
      end
      print 'Pull request for issue '
      print bold '#' + issue_number
      puts ' created'
    end
  end
end
