Gem::Specification.new do |s|

  s.authors = ['Tomasz Durka']
  s.date = Date.today.to_s
  s.email = 'tomasz@durka.pl'
  s.homepage = 'https://github.com/tomaszdurka/github_issues.git'
  s.license = 'MIT'

  s.summary = 'Command line tool for managing issues, pull-requests on GitHub platform'
  s.version = Git::VERSION

  s.add_runtime_dependency 'clamp', ">= 0.5"
  s.add_runtime_dependency 'git', ">= 1.2.5"
  s.add_runtime_dependency 'github-api', ">= 0.10"
  s.add_runtime_dependency 'term-ansicolor', ">= 1.2.0"

  s.files = [
    'lib/github_issues/command',
    'lib/github_issues/command/list',
    'lib/github_issues/command/checkout',
    'lib/github_issues/command/browse',
    'lib/github_issues/command/show',
    'lib/github_issues/command/open',
    'lib/github_issues/command/push',
    'lib/github_issues/command/pull_request',
    'lib/github_issues/command_manager'
  ]
  s.executables = ['gi']
end