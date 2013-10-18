module GithubIssues
  class Command < Clamp::Command

    include Term::ANSIColor

    attr_accessor :git_repo

    def initialize(invocation_path, context = {}, parent_attribute_values = {})
      super

      github_repo = get_github_repo
      Github.configure do |c|
        c.oauth_token = 'xxx'
        c.user = github_repo[:user]
        c.repo = github_repo[:name]
      end
    end

    # @return [Git::Base]
    def find_git_repo
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
      if find_git_repo.current_branch.match(/issue-([0-9]+)/).nil?
        raise 'Is not branch issue. Issue branches match `issue-XXX` pattern'
      end
      $1
    end

    def get_github_repo
      url = find_git_repo.remote(:upstream).url
      if url.nil?
        raise 'No `upstream` remote found, please run `setup`'
      end
      unless url.start_with?('git@github.com:', 'https://github.com/')
        raise 'Remote upstream points to non-github url: ' + url
      end
      if url.match(/github.com[:\/]([^\/]+)\/([^\/]+)\.git$/).nil?
        raise 'Can\'t extract `user/repo` data'
      end
      {:user => $1, :name => $2}
    end

  end
end