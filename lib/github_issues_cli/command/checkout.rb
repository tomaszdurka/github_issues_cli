module GithubIssuesCli
  class Command::Checkout < Command

    parameter 'issue-number', 'number of issue to be worked on', :attribute_name => :issue_number

    def execute
      branch_name = 'issue-' + issue_number
      repo = get_git_repo

      is_local_branch = repo.lib.branches_all.map(&:first).include? branch_name
      if is_local_branch
        repo.checkout branch_name
      else
        source = get_source_branch(issue_number)
        target = source
        if source.nil?
          github_repo = get_upstream_repo
          request = {:user => github_repo[:user], :repo => github_repo[:name], :number => issue_number}
          Github::Issues.new.get(request) rescue raise "Can't find issue ##{issue_number}"
          repo.remote('upstream').fetch
          source = 'upstream/master'
          target = 'origin/' + branch_name
        end
        repo.lib.command_proxy('checkout', ['-b', branch_name, source])
      end
      print on_green ' '
      print " Checked out ##{issue_number} "
      print "(#{source})" unless is_local_branch
      puts

      unless is_local_branch
        print on_green ' '
        puts " Setting upstream to (#{target})"
      remote_name, branch_name = target.split('/')
        repo.lib.command_proxy('config', ["branch.#{branch_name}.remote", remote_name])
        repo.lib.command_proxy('config', ["branch.#{branch_name}.merge", "refs/heads/#{branch_name}"])
      end
    end
  end
end
