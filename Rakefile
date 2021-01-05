require 'erb'
require 'dotenv/load'

ENV['GLOBAL_RUBY_VERSION'] = Pathname('.ruby-version').read.chomp!
ENV['DOCKER_BUILDKIT'] = '1'

BUILD_CONTEXTS = %w[
  base
  dotnet
  go
  haskell
  java
  npm
  php
  python
  ruby
  swift
].freeze

require 'aufgaben/release'
Aufgaben::Release.new

require 'aufgaben/bump/ruby'
Aufgaben::Bump::Ruby.new do |t|
  t.files = %w[
    .ruby-version
    base/Dockerfile.prepare.erb
  ]
end


namespace :dockerfile do
  desc 'Generate Dockerfile from a template'
  task :generate do
    BUILD_CONTEXTS.each do |build_context|
      path = Pathname(build_context)
      template = ERB.new((path / 'Dockerfile.erb').read)
      result = <<~EOD
        # !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        # NOTE: DO *NOT* EDIT THIS FILE.  IT IS GENERATED.
        # PLEASE UPDATE Dockerfile.erb INSTEAD OF THIS FILE
        # !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        #{template.result.chomp}
      EOD
      File.write(path / 'Dockerfile', result)
    end
  end

  desc 'Verify Dockerfile is committed'
  task :verify do
    begin
      sh 'git', 'diff', '--exit-code'
    rescue
      abort 'Run `bundle exec rake dockerfile:generate` and include the changes in commit'
    end
  end
end

namespace :docker do
  desc 'Run docker build'
  task :build => 'dockerfile:generate' do
    sh 'docker', 'build', '-t', image_name, '-f', "#{build_context}/Dockerfile", '.'
  end

  desc 'Run docker run with any command'
  task :run, [:command] do |_task, args|
    command = (args[:command] || '').split(/\s+/)
    sh 'docker', 'run', '--rm', image_name, *command
  end

  desc 'Run docker push'
  task :push do
    sh 'docker', 'login', '-u', docker_user, '-p', docker_password
    sh 'docker', 'push', image_name
    if tag_latest?
      sh 'docker', 'tag', image_name, image_name_latest
      sh 'docker', 'push', image_name_latest
    end
  end

  desc 'Run interactive shell in the specified Docker container'
  task :shell, [:extra_args] do |_task, args|
    run_args = (args[:extra_args] || '').split(/\s+/)
    workdir = "/work"
    sh 'docker', 'run', '-it', '--rm', "--volume=#{Dir.pwd}:#{workdir}", "--workdir=#{workdir}", *run_args, image_name, 'bash'
  end
end

def image_name
  "sider/devon_rex_#{build_context}:#{tag}"
end

def image_name_latest
  "sider/devon_rex_#{build_context}:latest"
end

def build_context
  ENV.fetch('BUILD_CONTEXT')
end

def tag
  key = 'TAG'
  ENV.fetch(key).tap { |value| abort "Environment variable `#{key}` must not be empty." if value.empty? }
end

def tag_latest?
  ENV['TAG_LATEST'] == 'true'
end

def docker_user
  ENV.fetch('DOCKER_USER')
end

def docker_password
  ENV.fetch('DOCKER_PASSWORD')
end
