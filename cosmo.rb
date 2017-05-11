#!/usr/bin/env ruby
require 'optparse'
require 'pp'

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

      opts.on("-v", "--[no-]verbose", "Run verbosely") do |v|
        options[:verbose] = v
      end

    end

    opt_parser.parse!(args)
    options

  end # self.parse

end # OptparseCosmo

options = OptparseCosmo.parse(ARGV)

pp options
pp ARGV
