module GithubIssues
  class Command::Checkout < Command

    parameter "issue-number", "number of issue to be worked on", :attribute_name => :issue_number

    def execute
      branch_name = 'issue-' + issue_number
      repo = get_git_repo
      source = nil
      if repo.lib.branches_all.map(&:first).include? branch_name
        repo.checkout branch_name
      else
        source = get_source issue_number
        repo.lib.checkout source, :new_branch => branch_name
      end
      print on_green ' '
      print ' Checked out #' + issue_number
      print ' (' + source.split('/').first.sub(/^gi-/, '') + ')' if source
      puts
    end
  end
end
