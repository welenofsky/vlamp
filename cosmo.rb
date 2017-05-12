#!/usr/bin/env ruby
require 'optparse'
require 'pp'

class Cosmo

  DEPENDENCIES = ['python2.7', 'pip', 'vagrant']

  def initialize(*args)
    # TODO stub
    # pp args
    # exit

    @options = args[0]

    # Verify user has required programs to continue
    DEPENDENCIES.each do |dep|
      unless command?(dep)
        puts "Can not find #{dep}. Please install it to continue"
        puts "https://www.vagrantup.com/downloads.html" if dep == 'vagrant'
        exit
      end
    end

    # Check if have virtualenv
    unless command?('virtualenv')
      puts 'Installing virtualenv, password required...'
      do_command('sudo pip install virtualenv',
                 'install virtualenv')
    end

    # Check for .env
    unless FileTest.exist?('.env/bin/activate')
      puts 'Creating virtualenv'
      do_command('virtualenv .env --python=python2.7',
                 'create .env virtualenv')
    end

    # Verify and/or install ansible into venv
    unless FileTest.exist?('.env/bin/ansible')
      puts 'Installing ansible'
      do_command('.env/bin/pip install -r requirements.txt',
                 'install ansible')
    end

    unless FileTest.exist?(File.expand_path('~/.vagrant.d/insecure_private_key'))
      puts "Could not find vagrant private key, unable to deploy to vagrant. Exiting..."
      exit
    end

    send(@options[:command])

  end

  # Used to call correct playbook or to edit config files.
  def init
    # TODO stub
    puts "Configuring project..."

    # Inventory File
    loop do
      puts "What environment are you setting up? Example: local, prd:"
      @inventory = STDIN.gets.chomp
      break unless @inventory.empty?
    end

    unless File.exist?("config/#{@inventory}")
      # Create file

    end

  end

  def deploy
    # --limit=#{@env} ??
    `ansible-playbook -i #{@inventory} #{@playbook} --private-key=~/.vagrant.d/insecure_private_key`
    unless $!.success?
      puts "Deploying project failed! Check above for more descriptive error message"
    end
  end

  def provision
    `ansible-playbook -i #{@inventory} #{@playbook} --private-key=~/.vagrant.d/insecure_private_key`
    unless $!.success?
      puts "Provisioning project failed! Check above for more descriptive error message"
    end
  end

  # Helper Functions
  def command?(name)
    `which #{name}`
    $?.success?
  end

  # Do command and report error
  def do_command(cmd, error_msg)
    system("#{cmd}")
    unless $!.success?
      puts "Failed to #{error_msg}, Exiting..."
      exit
    end
  end

end

class OptparseCosmo

  ACTIONS = ['init', 'deploy', 'provision']

  def self.parse(args)

    options = {}
    opt_parser = OptionParser.new do |opts|
      opts.banner = "Usage: example.rb <command> [options]"
      opts.separator ""
      opts.separator "Where command is one of the following:"
      opts.separator "  init\t\t- Start a new project"
      opts.separator "  deploy\t- Update existing project source code"
      opts.separator "  provision\t- Setup environment"

      action = args[0]
      unless ACTIONS.index(action)
        puts opts
        exit
      end

      options[:command] = action

      opts.on("-v", "--verbose", "Run verbosely") do |v|
        options[:verbose] = v
      end

    end

    opt_parser.parse!(args)
    options

  end # self.parse

end # OptparseCosmo

options = OptparseCosmo.parse(ARGV)
Cosmo.new(options)

# pp options
# pp ARGV