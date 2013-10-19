module GithubIssues
  class Command_manager < Clamp::Command

    subcommand "list", "Lists issues", Command::List
    subcommand "checkout", "Checkouts specifc issue", Command::Checkout
    subcommand "show", "Show current issue details", Command::Show
    subcommand "browse", "Navigate to issue HTML url", Command::Browse
    subcommand "open", "Open new issue", Command::Open
  end
end
