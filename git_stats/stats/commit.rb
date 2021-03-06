class CommitStats
  attr_reader :commits
  attr_reader :files_added
  attr_reader :files_deleted
  attr_reader :lines_added
  attr_reader :lines_deleted
  attr_reader :files
  attr_reader :file_type_stats
  attr_reader :lines
  attr_reader :first_commit
  attr_reader :last_commit

  def days
    @days.size
  end

  def initialize
    @commits = 0
    @files_added = 0
    @files_deleted = 0
    @lines_added = 0
    @lines_deleted = 0
    @files = 0
    @file_type_stats = {
      ".rb" => {add: 0, remove: 0},
      ".js" => {add: 0, remove: 0},
      ".yml" => {add: 0, remove: 0},
      ".spec" => {add: 0, remove: 0},
      "others" => {add: 0, remove: 0},
    }
    @lines = 0
    @first_commit = nil
    @last_commit = nil
    @days = Array.new
  end

  def update(commit)
    @commits += 1
    @files_added += commit[:files_added]
    @files_deleted += commit[:files_deleted]
    @lines_added += commit[:lines_added]
    @lines_deleted += commit[:lines_deleted]
    @files = @files_added - @files_deleted
    @lines = @lines_added - @lines_deleted
    @file_type_stats.keys.each do |key|
      @file_type_stats[key][:add] += commit[:file_stats][key][:add]
      @file_type_stats[key][:remove] += commit[:file_stats][key][:remove]
    end

    @first_commit ||= commit[:time]
    @last_commit ||= commit[:time]

    @first_commit = commit[:time] if commit[:time] < @first_commit
    @last_commit = commit[:time] if commit[:time] > @last_commit

    day = commit[:time].year * 10000 + commit[:time].month * 100 + commit[:time].day
    @days << day unless @days.include? day
  end
end

