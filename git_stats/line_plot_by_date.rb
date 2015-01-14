class LinePlotByDate
  attr_reader :title
  attr_reader :data_sets
  attr_reader :outfile

  def initialize(title, data_sets, outfile)
    @title = title
    @data_sets = data_sets
    @outfile = outfile
  end

  def export_file
    g = Gruff::Line.new
    g.title = @title
    g.labels = formulate_labels @data_sets
    formulate_data(@data_sets).each do |key, value|
      g.data key.to_sym, value
    end
    g.write("#{@outfile}.png")
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

  def formulate_data period_stats
    period_data = {
      "add .rb" => [],
      "remove .rb" => [],
      "add .js" => [],
      "remove .js" => [],
      "add .yml" => [],
      "remove .yml" => [],
      "add .spec" => [],
      "remove .spec" => []
    }
    period_stats.each_value do |date_stats|
      file_stats = date_stats.file_type_stats
      file_stats.each do |file_key, file_value|
        next if file_key == "others"
        file_value.each do |type, value|
          name = "#{type.to_s} #{file_key}"
          value = (type == :remove) ? -value : value
          period_data[name].push(value)
        end
      end
    end
    period_data
  end
end
