#!/usr/bin/env ruby

require "optparse"
require "fileutils"
require "date"
require "rubygems"
require "pry-rails"
require "./git_stats/author"
require "./git_stats/yearmonth"
require "./git_stats/git"

require "./git_stats/stats"
require "./git_stats/stats/commit"
require "./git_stats/stats/commit/author"
require "./git_stats/stats/commit/time"
require "./git_stats/stats/file"
require "./git_stats/stats/file/filetype"

require "./git_stats/statgen"

$options = {
  out: "stats",
  verbose: false,
  start_date: nil,
  end_date: nil
}

parser = OptionParser.new do |opts|
  opts.banner = "Usage git_stats.rb [option] <gitdir> <start date(yyyy/mm/dd)> <end data()>"

  opts.on("-v", "--[no-]verbose", "verbose mode") do |arg|
    $options[:verbose] = arg
  end
end

parser.parse!
