module GithubIssuesCli
  class Command::List < Command

    option '--mine', :flag, 'show only mine issues'

    def execute
      github_repo = get_upstream_repo
      repo_name = github_repo[:user] + '/' + github_repo[:name]
      query = [
        "repo:#{repo_name}",
      ]
      query.push("state:open")
      query.push("assignee:#{@username}") if mine?
      result = Github::Client::Search.new.issues :q => query.join(' ')

      result.items.each do |issue|
        if not issue.assignee.nil? and issue.assignee.login == @username
          print yellow '●'
        else
          print ' '
        end
        print bold(issue.number.to_s.rjust(5) + ':')
        print ' ' + issue.title
        puts
      end
    end
  end
end
