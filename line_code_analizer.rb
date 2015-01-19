#!/usr/bin/env ruby

require "optparse"
require "fileutils"
require "date"
require "rubygems"
require "gruff"
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
require "./git_stats/stats/file/file_catefory"
require "./git_stats/statgen"
require "./git_stats/line_plot_by_date"
require "./git_stats/bar_chart"

$options = {
  respos: "../",
  path: "../",
  branch: nil,
  start_date: nil,
  end_date: Date.today.to_s,
  file_type: ""
}

parser = OptionParser.new do |opts|
  opts.banner = "Usage: ruby line_code_analizer.rb -r [resposibility] -p [path] -b [branch] -f [from: YYYY/MM/DD] -t [to: YYYY/MM/DD] -c [file type: rb,js,yml,spec]"

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

  opts.on("-c", "--file_type=arg" ,"classification of file") do |arg|
    $options[:file_type] = arg
  end

  opts.on_tail("-h", "--help", "this help") do
    puts opts
    exit 0
  end
end

parser.parse!
stats = StatGen.new
stats.start_date = Date.parse($options[:start_date]) unless $options[:start_date].nil?
stats.end_date = Date.parse($options[:end_date])
stats << [$options[:respos], $options[:path], "HEAD"]
stats.calc($options[:branch])
line_graph = LinePlotByDate.new("Lines Added/Deleted", stats.date_stats, "line_stats_by_date" )
line_graph.export_file($options[:file_type])
