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
  respos: "../",
  path: "../",
  branch: nil,
  start_date: nil,
  end_date: nil,
  file_type: false
}

parser = OptionParser.new do |opts|
  opts.banner = "Usage git_stats.rb -r [resposibility] -p [path] -b [branch] -f [from_YYYYMMDD] -t [to_YYYYMMDD] -c [classify based on file type]"

  opts.on("-r", "--respos=arg", "resposibility name") do |arg|
    $options[:respos] = arg
  end

  opts.on("-p", "--path=arg", "directory of resposibility") do |arg|
    $options[:path] = arg
  end

  opts.on("-b", "--branch=arg", "branch name") do |arg|
    $options[:branch] = arg
  end

  opts.on("-f", "--start_date=arg", "from date") do |arg|
    $options[:start_date] = arg
  end

  opts.on("-t", "--end_date=arg", "to date") do |arg|
    $options[:end_date] = arg
  end

  opts.on("-c", "classify file statistics") do |arg|
    $options[:file_type] = arg
  end
end

parser.parse!
stats = StatGen.new
stats.start_date ||= Date.parse($options[:start_date])
stats.end_date ||= Date.pare($options[:start_date])
stats << [$options[:respos], $options[:path], "HEAD"]
stats.calc($options[:branch])
