Gem::Specification.new do |s|

  s.name = 'github_issues_cli'
  s.authors = ['Tomasz Durka']
  s.date = Date.today.to_s
  s.email = 'tomasz@durka.pl'
  s.homepage = 'https://github.com/tomaszdurka/github_issues_cli.git'
  s.license = 'MIT'

  s.summary = 'Command line tool for managing issues, pull-requests on GitHub platform'
  s.version = '0.3.1'

  s.add_runtime_dependency 'clamp', '~> 0.6.0'
  s.add_runtime_dependency 'git', '~> 1.2.8'
  s.add_runtime_dependency 'github_api', '~> 0.12'
  s.add_runtime_dependency 'term-ansicolor', '~> 1.2.0'

  s.files = Dir.glob 'lib/**/*'
  s.executables = ['gi']
end
