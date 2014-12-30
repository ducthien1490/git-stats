class FileCategory
  attr_accessor :type
  attr_accessor :lines_added
  attr_accessor :lines_removed

  def initialize
    @type = ""
    @lines_added = 0
    @lines_removed = 0
  end

  def update(commit)
    @lines_added += commit[:file_stats][@type][:add]
    @lines_removed += commit[:file_stats][@type][:remove]
  end
end
