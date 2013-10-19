module GithubIssuesCli
  class Command::Pull_request < Command

    def execute
      github_repo = get_github_repo
      issue_number = get_issue_number
      source = @username + ':issue-' + issue_number
      begin
        request = {
            :user => github_repo[:user],
            :repo => github_repo[:name],
            :head => source,
            :base => github_repo[:user] + ':master',
            :issue => issue_number
        }
        Github::PullRequests.new.create request
      rescue
        unless get_source(issue_number).nil?
          raise 'Pull-request for issue #' + issue_number + ' already exists'
        end
        raise 'Internal error: Cannot create pull-request'
      end
      print 'Pull request for issue '
      print bold '#' + issue_number
      puts ' created'
    end
  end
end
