class LinePlotByDate
  attr_reader :title
  attr_reader :data_sets
  attr_reader :outfile

  def initialize(title, data_sets, outfile)
    @title = title
    @data_sets = data_sets
    @outfile = outfile
  end

  def export_file(file_types)
    formulate_data(@data_sets, file_types).each do |key, value|
      g = Gruff::Line.new
      g.title = "#{@title} #{key.to_s} file"
      g.labels = formulate_labels @data_sets
      value.each do |type, val|
        g.data type, val
      end
      g.write("#{@outfile} #{key.gsub(".", "")} file.png")
    end
  end

  private
  def formulate_labels data
    labels = data.keys
    formated_labels = labels.map do |label|
      if label == labels.first || label == labels.last
        label.to_s
      else
        " "
      end
    end
    Hash[(0..labels.size).zip formated_labels]
  end

  def formulate_data(period_stats, file_types)
    period_data = {
      ".rb" => {add: [], remove: []},
      ".js" => {add: [], remove: []},
      ".yml" => {add: [], remove: []},
      ".spec" => {add: [], remove: []},
    }
    period_stats.each_value do |date_stats|
      file_stats = date_stats.file_type_stats
      file_stats.each do |file_key, file_value|
        next if file_key == "others"
        file_value.each do |key, val|
          val = -val if key == :remove
          period_data[file_key][key] << val
        end
      end
    end
    if file_types.length > 0
      types = file_types.split(",").map{|type| type.insert(0, ".")}
      period_data.keys.each{|type| period_data.delete(type) unless types.include?(type)}
    end
    period_data
  end
end
