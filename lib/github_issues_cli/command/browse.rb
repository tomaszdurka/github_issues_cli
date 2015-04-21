module GithubIssuesCli
  class Command::Browse < Command

    def execute
      github_repo = get_upstream_repo
      url = 'https://github.com/' + github_repo[:user] + '/' + github_repo[:name] + '/issues/' + get_issue_number
      system('open ' + url)
    end
  end
end
