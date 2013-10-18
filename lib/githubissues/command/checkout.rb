module GithubIssues
  class Command::Checkout < Command

    parameter "issue-number", "number of issue to be worked on", :attribute_name => :issue_number

    def execute
      issues_client = Github::Issues.new
      issue = issues_client.get :number => issue_number
      puts issue.url
    end
  end
end
