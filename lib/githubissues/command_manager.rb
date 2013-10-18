module GithubIssues
  class Command_manager < Clamp::Command

    subcommand "browse", "Navigate to issue HTML url", Command::Browse
    subcommand "open", "Open new issue", Command::Open
    subcommand "show", "Show current issue details", Command::Show
    subcommand "checkout", "Checkouts specifc issue", Command::Checkout
  end
end
