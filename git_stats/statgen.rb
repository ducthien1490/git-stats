class StatGen
  attr_accessor :verbose
  attr_accessor :debug
  attr_accessor :quiet
  attr_accessor :future
  attr_accessor :maxage
  attr_accessor :commitcache
  attr_accessor :include_mail
  attr_accessor :start_date
  attr_accessor :end_date
  attr_reader :repos

  attr_reader :num_commits

  attr_reader :general_stats
  attr_reader :author_stats
  attr_reader :year_stats
  attr_reader :month_stats
  attr_reader :yearmonth_stats
  attr_reader :date_stats
  attr_reader :hour_stats
  attr_reader :wday_stats
  attr_reader :lastweeks_stats
  attr_reader :file_category_stats

  attr_reader :file_stats
  attr_reader :filetype_stats

  def initialize
    @repos = Array.new
    @repostate = Hash.new

    @verbose = false
    @debug = false
    @quiet = false
    @future = true
    @maxage = 0
    @commitcache = nil
    @include_mail = false

    @num_commits = 0
    @general_stats = CommitStats.new
    @author_stats = AuthorsCommitStats.new
    @year_stats = YearCommitStats.new
    @month_stats = MonthCommitStats.new
    @yearmonth_stats = YearMonthCommitStats.new
    @date_stats = DateCommitStats.new
    @hour_stats = HourCommitStats.new
    @wday_stats = DayOfWeekCommitStats.new
    @lastweeks_stats = LastWeeksCommitStats.new
    @file_category_stats = [".rb", ".js", ".yml", ".spec", "others"].map do |type|
      file_cat = FileCategory.new
      file_cat.type = type
      file_cat
    end

    @file_stats = FileStats.new
    @filetype_stats = FileTypeFileStats.new
  end

  def num_authors
    @author_stats.size
  end

  def clear_repos
    @repos = Array.new
  end

  def check_repostate
    @repostate.keys.each do |name|
      return false if @repos.find { |x| x.name == name }.nil?
    end
    true
  end

  def add(name, directory, ref = 'HEAD')
    cache = nil
    unless @commitcache.nil?
      cache = File.join(@commitcache, ".commitcache.#{name.tr('^a-zA-Z0-9_', '_')}")
    end
    @repos << Git.new(name, directory, ref, @debug, cache)
  end

  def <<(value)
    add(value[0], value[1], value[2])
  end

  def calc(branch_name)
    # reset because of caching for now
    @file_stats = FileStats.new
    @filetype_stats = FileTypeFileStats.new

    @repos.each do |repo|
      @repostate[repo.name] ||= {
        :last => nil
      }

      puts "  repository '#{repo.name}' ..." unless @quiet

      repo.get_commits(@repostate[repo.name][:last], branch_name) do |commit|
        next if !@future && (commit[:time] > Time.now)
        next if (@maxage > 0) && ((Time.now - commit[:time]) > @maxage)
        next if @start_date && (commit[:time].to_date < @start_date)
        next if @end_date && (commit[:time].to_date > @end_date)

        puts "    commit #{@num_commits} ..." if @verbose && ((@num_commits % 100) == 0)

        @num_commits += 1
        @general_stats.update(commit)
        @author_stats.update(commit)
        @year_stats.update(commit)
        @month_stats.update(commit)
        @yearmonth_stats.update(commit)
        @date_stats.update(commit)
        @hour_stats.update(commit)
        @wday_stats.update(commit)
        @lastweeks_stats.update(commit)
        @file_category_stats.each do |file_cat|
          file_cat.update(commit)
        end

        @repostate[repo.name][:last] = commit[:hash]
      end

      repo.get_files do |file|
        @file_stats.update(file)
        @filetype_stats.update(file)
      end
    end
  end
end

