module GithubIssuesCli
  class CommandManager < Clamp::Command

    subcommand 'list', 'Lists issues', Command::List
    subcommand 'checkout', 'Checkouts specifc issue', Command::Checkout
    subcommand 'show', 'Show current issue details', Command::Show
    subcommand 'browse', 'Navigate to issue HTML url', Command::Browse
    subcommand 'open', 'Open new issue', Command::Open
    subcommand 'push', 'Push current state to repo', Command::Push
    subcommand 'pull-request', 'Creates pull-request out of current issue', Command::Pull_request
  end
end
