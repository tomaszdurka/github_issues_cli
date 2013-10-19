module GithubIssues
  class Command::Checkout < Command

    parameter "issue-number", "number of issue to be worked on", :attribute_name => :issue_number

    def execute
      branch_name = 'issue-' + issue_number
      repo = get_git_repo
      if repo.lib.branches_all.map(&:first).include? branch_name
        repo.checkout branch_name
      else
        repo.lib.checkout get_source, :new_branch => branch_name
      end
      puts 'Checked out #' + issue_number
    end

    def get_source
      pull_requests_client = Github::PullRequests.new
      pull_request  = pull_requests_client.get :number => issue_number  rescue return 'upstream/master'
      user = pull_request.head.repo.owner.login
      url = pull_request.head.repo.ssh_url
      ref = pull_request.head.ref
      remote_name = 'gi-' + user
      repo = get_git_repo
      remote = repo.remote remote_name
      if remote.url.nil?
        print 'Setting up remote `' + remote_name + '`...'
        remote = repo.add_remote remote_name, url
        puts ' Done'
      end
      if remote.url != url
        raise '`' + remote_name + '` remote\'s url differs from expected: `' + remote.url + ' != ' + url + '`'
      end
      remote.fetch
      remote.name + '/' + ref
    end
  end
end
