#!/usr/bin/env ruby
require 'optparse'
require 'pp'

class Cosmo

  DEPENDENCIES = ['python2.7', 'pip', 'vagrant']

  @config = Hash.new
  @config[:ansible_name] = 'localhost',
  @config[:ansible_user] = 'vagrant'
  @config[:ansible_port] = '2222',
  @config[:ansible_host] = 'localhost',
  @config[:dbname] = 'test',
  @config[:dbuser] = 'test',
  @config[:dbpassword] = 'secret',
  @config[:dbport] = '3306',
  @config[:sync_folder] = '/home/{{ username }}/src',
  @config[:document_root] = '/'
  
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

  """
  Commands:
    - init
    - deploy
    - provision

  Vagrant Helper Commands:
    - up
    - down
    - halt
    - destroy (-f)
    - phoenix
  """

  # Used to call correct playbook or to edit config files.
  def init
    # TODO stub
    puts "Configuring project..."

    @inventory = get_variable('What environment are you setting up (local): ', 'local')

    unless @inventory == 'local'
        @config[:ansible_name] = get_variable('What is the IP (#{@config[:ansible_name]}): ', @config[:ansible_name])
        @config[:ansible_user] = 'localhost'
        @config[:ansible_port] = '2222',
        @config[:ansible_host] = 'localhost',
    end

    unless File.exist?("config/#{@inventory}")
      # Create file

    end

  end

  def deploy
    @tags = ['deploy']
    # --limit=#{@env} ??
    `ansible-playbook -i #{@inventory} #{@playbook}`
    unless $!.success?
      puts "Deploying project failed! Check above for more descriptive error message"
    end
  end

  def provision
    @tags = ['untagged']
    @inventory = 'config/local'
    ansible_playbook('Provisioning vagrant box')
  end

  """
  Helper Functions
  """
  def command?(name)
    `command -v #{name} 2> /dev/null | grep -q "#{name}"`
    $?.success?
  end

  # Do command and report error
  def do_command(cmd, error_msg)
    system(cmd)
    unless $!.success?
      puts "Failed to #{error_msg}, Exiting..."
      exit
    end
  end

  def ansible_playbook(task)
    cmd = "ansible-playbook -i #{@inventory} playbook.yml --private-key=~/.vagrant.d/insecure_private_key --tags \"#{@tags.join(',')}\" --limit=local"
    system(cmd)
    unless $!.success?
      puts "#{task} failed! Check above for more descriptive error message"
    end
  end

  def get_variable(msg, default)
    print msg
    temp = STDIN.gets.chomp
    temp.empty? ? default : temp 
  end

end

class OptparseCosmo

  COMMANDS = ['init', 'deploy', 'provision', 'up', 'halt', 'phoenix', 'ssh']

  def self.parse(args)

    options = {}
    opt_parser = OptionParser.new do |opts|
      opts.banner =  "Usage: example.rb <command> [options]"
      opts.separator ""
      opts.separator "  Where command is one of the following:"
      opts.separator "    init      - Start a new project"
      opts.separator "    deploy    - Update existing project source code"
      opts.separator "    provision - Setup environment"
      opts.separator "    up        - Bring Vagrant Box Up"
      opts.separator "    down      - Bring Vagrant Box Down"
      opts.separator "    phoenix   - Destroy and Resurrect Vagrant Box"
      opts.separator "    ssh       - SSH into Vagrant Box"


      command = args[0]
      unless COMMANDS.index(command)
        puts opts
        exit
      end

      options[:command] = command

      opts.on("-f", "--force", "Force") do |v|
        options[:force] = v
      end

    end

    opt_parser.parse!(args)
    options

  end # self.parse

end # OptparseCosmo

options = OptparseCosmo.parse(ARGV)
pp options
# Cosmo.new(options)

# pp options
# pp ARGV
