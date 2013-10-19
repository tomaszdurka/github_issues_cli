module GithubIssuesCli
  class Command::List < Command

    option "--mine", :flag, "show only mine issues"

    def execute
      github_repo = get_github_repo
      issues_client = Github::Issues.new
      request = {:user => github_repo[:user], :repo => github_repo[:name]}
      request.store(:assignee, @username) if mine?
      issues = issues_client.list request

      issues.each do |issue|
        if not issue.assignee.nil? and issue.assignee.login == @username
          print on_yellow ' '
        else
          print ' '
        end
        print bold ' ' + ('#' + issue.number.to_s).rjust(6)
        print ' ' + issue.title
        puts
      end
    end
  end
end
