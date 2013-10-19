module GithubIssues
  class Command < Clamp::Command

    include Term::ANSIColor

    attr_accessor :git_repo

    def initialize(invocation_path, context = {}, parent_attribute_values = {})
      super
      authenticate
    end

    def authenticate
      auth_dirname = ENV['HOME'] + '/.github-issues/'
      Dir.mkdir auth_dirname unless Dir.exists? auth_dirname

      auth_path = auth_dirname + 'token'
      if File.exists? auth_path
        token = File.new(auth_path, 'r').gets.chomp
      else
        print 'Please provide GitHub token: '
        token = $stdin.gets.chomp
        File.new(auth_path, 'w').puts(token)
      end

      Github.configure do |c|
        c.oauth_token = token
      end
    end

    # @return [Git::Base]
    def get_git_repo
      unless @git_repo
        dir = Dir.getwd + '/'
        until Dir.exists? dir + '.git' do
          if dir == '/'
            raise StandardError, 'Git not found'
          end
          dir = File.dirname(dir)
        end
        @git_repo = Git.open dir
      end
      @git_repo
    end

    def get_issue_number
      if get_git_repo.current_branch.match(/issue-([0-9]+)/).nil?
        raise 'Is not branch issue. Issue branches match `issue-XXX` pattern'
      end
      $1
    end

    def get_github_repo
      url = get_git_repo.remote(:upstream).url
      if url.nil?
        raise 'No `upstream` remote found, please run `setup`'
      end
      unless url.start_with?('git@github.com:', 'https://github.com/')
        raise 'Remote upstream points to non-github url: ' + url
      end
      if url.match(/github.com[:\/]([^\/]+)\/([^\/]+)\.git$/).nil?
        raise 'Can\'t extract `user/repo` data from upstream remote'
      end
      {:user => $1, :name => $2}
    end

    def get_source issue_number
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