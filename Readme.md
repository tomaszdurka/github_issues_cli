# github-issues
`gi`is a command line tool to CRUD github issues. It maps every issue to a branch `issue-<issue-number>`.

The tool helps you to create these branches, work on them, and create pull-requests.


## Installation
Library is bundled in gem, simply:
```
gem install github_issues_cli
```

## Usage
```
Usage:
    gi [OPTIONS] SUBCOMMAND [ARG] ...

Parameters:
    SUBCOMMAND                    subcommand
    [ARG] ...                     subcommand arguments

Subcommands:
    list                          Lists issues
    checkout                      Checkouts specific issue
    show                          Show current issue details
    browse                        Navigate to issue HTML url
    open                          Open new issue
    comment                       Comment on current issue
    push                          Push current state to repo
    pull-request                  Creates pull-request out of current issue

Options:
    -h, --help                    print help
```


## Workflow
Create a new issue:
```
gi open
```

Or start working on an existing issue:
```
gi checkout <issue-number>
```

..do some work, commit changes as usual (`git commit`)..

When your work is ready, push it to your origin and create a pull request:
```
gi push
gi pull-request
```

Before the pull request has been merged, you can push additional commits:
```
gi push
```