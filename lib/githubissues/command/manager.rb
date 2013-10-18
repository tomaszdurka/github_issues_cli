module GithubIssues
  class Command::Manager < Command

    subcommand "browse", "Navigate to issue HTML url", Command::Browse
    subcommand "open", "Open new issue", Command::Open
    subcommand "show", "Show current issue details", Command::Show
  end
end
