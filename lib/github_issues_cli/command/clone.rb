module GithubIssuesCli
  class Command::Clone < Command

    parameter 'repository', 'name of the Github repository in owner/repo format', :attribute_name => :repository
    parameter '[target]', 'target location for clone', :attribute_name => :target, :default => ''

    def execute
      owner, name = repository.split('/')
      upstream_repo = Github::Repos.new.get(:user => owner, :repo => name)
      if upstream_repo.owner.login == @username
        origin_repo = upstream_repo
      else
        forks = Github::Repos::Forks.new.list(:user => owner, :repo => name)
        fork = forks.find do |fork|
          fork.owner.login == @username
        end

        unless fork
          puts "Forking #{repository} for #{@username}"
          fork = Github::Repos::Forks.new.create(:user => owner, :repo => name)
        end
        origin_repo = fork
      end

      path = Pathname.new(target).expand_path(Dir.getwd).to_s
      puts "Cloning #{repository} into #{path}"
      git_repo = Git.clone(origin_repo.ssh_url, origin_repo.name, :path => path)
      git_repo.add_remote 'upstream', upstream_repo.ssh_url
    end
  end
end
