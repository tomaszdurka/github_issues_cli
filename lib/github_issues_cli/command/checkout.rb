module GithubIssuesCli
  class Command::Checkout < Command

    parameter 'issue-number', 'number of issue to be worked on', :attribute_name => :issue_number

    def execute
      branch_name = 'issue-' + issue_number
      repo = get_git_repo
      source = nil
      if repo.lib.branches_all.map(&:first).include? branch_name
        repo.checkout branch_name
      else
        source = get_source_branch(issue_number)
        if source.nil?
          github_repo = get_upstream_repo
          request = {:user => github_repo[:user], :repo => github_repo[:name], :number => issue_number}
          Github::Issues.new.get(request) rescue raise "Can't find issue ##{issue_number}"
          repo.remote('upstream').fetch
          source = 'upstream/master'
        end
        repo.checkout source, :new_branch => branch_name
      end
      print on_green ' '
      print ' Checked out #' + issue_number
      print ' (' + source.split('/').first + ')' if source
      puts
    end
  end
end
