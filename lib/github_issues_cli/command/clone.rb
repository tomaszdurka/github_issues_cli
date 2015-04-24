module GithubIssuesCli
  class Command::Clone < Command

    parameter 'repository', 'name of the Github repository in owner/repo format', :attribute_name => :repository
    parameter '[target]', 'target location for clone', :attribute_name => :target

    def execute
      owner, name = repository.split('/')
      upstream_repo = Github::Client::Repos.new.get(:user => owner, :repo => name)
      if upstream_repo.owner.login == @username
        origin_repo = upstream_repo
      else
        forks = Github::Client::Repos::Forks.new.list(:user => owner, :repo => name)
        fork = forks.find do |fork|
          fork.owner.login == @username
        end

        unless fork
          puts "Forking #{repository} for #{@username}"
          fork = Github::Client::Repos::Forks.new.create(:user => owner, :repo => name)
        end
        origin_repo = fork
      end

      target_directory = target || origin_repo.name
      target_path = Pathname.new(target_directory).expand_path(Dir.getwd)
      puts "Cloning #{repository} into #{target_path.to_s}"
      git_repo = Git.clone(origin_repo.ssh_url, target_path.basename.to_s, :path => target_path.dirname.to_s)
      git_repo.add_remote 'upstream', upstream_repo.ssh_url
    end
  end
end
