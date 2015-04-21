module GithubIssuesCli
  class Command < Clamp::Command

    include Term::ANSIColor

    attr_accessor :git_repo, :username

    def initialize(invocation_path, context = {}, parent_attribute_values = {})
      super
      authenticate
    end

    def authenticate
      config_dirname = ENV['HOME'] + '/.github-issues/'
      Dir.mkdir config_dirname unless Dir.exists? config_dirname

      config_path = config_dirname + 'config'
      if File.exists? config_path
        file = File.new(config_path, 'r')
        config = JSON.parse file.gets
        file.close
        @username, token = config.values_at 'username', 'token'
      else
        print 'Please provide GitHub token: '
        token = $stdin.gets.chomp
        @username = Github::Users.new.get(:oauth_token => token).login
        config = {:username => @username, :token => token}
        file = File.new(config_path, 'w')
        file.puts config.to_json
        file.close
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

    def get_upstream_repo
      url = get_git_repo.remote(:upstream).url
      if url.nil?
        raise 'No `upstream` remote found, please configure it first'
      end
      unless url.start_with?('git@github.com:', 'https://github.com/')
        raise 'Remote upstream points to non-github url: ' + url
      end
      if url.match(/github.com[:\/]([^\/]+)\/([^\/]+)\.git$/).nil?
        raise 'Can\'t extract `user/repo` data from upstream remote'
      end
      {:user => $1, :name => $2}
    end

    def get_pullrequest(issue_number)
      upstream_repo = get_upstream_repo
      request = {
        :user => upstream_repo[:user],
        :repo => upstream_repo[:name],
        :number => issue_number,
      }
      Github::PullRequests.new.get(request) rescue nil
    end

    def get_source_branch(issue_number)
      git_repo = get_git_repo
      pullrequest = get_pullrequest(issue_number)

      username = pullrequest.head.repo.owner.login
      remote_name = username == @username ? 'origin' : username
      remote_url = pullrequest.head.repo.ssh_url
      branch_name = pullrequest.head.ref

      source_remote = git_repo.remote(remote_name)
      if source_remote.url.nil?
        print 'Setting up remote `' + remote_name + '`...'
        source_remote = git_repo.add_remote(remote_name, remote_url)
        puts ' Done'
      end

      source_remote.fetch
      source_remote.name + '/' + branch_name
    end

    def run(arguments)
      begin
        super
      rescue Exception => e
        print on_red ' '
        print bold ' Error: '
        if e.message.empty?
          puts 'Unknown error/Interrupt'
        else
          puts e.message
        end
        exit 1
      end
    end
  end
end
