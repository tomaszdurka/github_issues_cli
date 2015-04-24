module GithubIssuesCli
  class Command::Show < Command

    def execute
      github_repo = get_upstream_repo
      issue_number = get_issue_number
      request = {:user => github_repo[:user], :repo => github_repo[:name], :number => issue_number}
      issue = Github::Client::Issues.new.get request
      comments = Github::Client::Issues::Comments.new.list request

      puts
      print bold issue_number + ': ' + issue[:title] + ' '
      if issue[:state] == 'open'
        print white on_green [:state]
      else
        print white on_red issue[:state]
      end
      puts
      if issue[:body]
        puts issue[:body]
        puts
      end
      puts

      comments.each do |c|
        print yellow '@' + c.user.login
        puts ':'
        puts c[:body]
        puts
      end
    end
  end
end
