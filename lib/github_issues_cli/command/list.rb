module GithubIssuesCli
  class Command::List < Command

    parameter '[query]', 'github search query', :attribute_name => :custom_query
    option '--mine', :flag, 'show only mine issues', :attribute_name => :mine
    option '--show-closed', :flag, 'show closed issues too', :attribute_name => :show_closed

    def execute
      github_repo = get_upstream_repo
      repo_name = github_repo[:user] + '/' + github_repo[:name]
      query = [
        "repo:#{repo_name}",
      ]
      query.push("state:open") unless show_closed?
      if custom_query.nil?
        query.push("assignee:#{@username}") if mine?
      else
        query.push(custom_query)
      end
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
