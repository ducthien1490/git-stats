class LinePlotByDate
  attr_reader :title
  attr_reader :date_labels
  attr_reader :data_sets
  attr_reader :outfile

  def initialize(title, date_labels, data, outfile)
    @title = title
    @date_labels = date_labels
    @data_sets = data
    @outfile = outfile
  end

  def export_file
    g = Gruff::Line.new
    g.title = @title
    g.labels = formulate_labels @date_labels
    @data_sets.each do |data|
      g.data data[:name].to_sym, data[:value]
    end
    g.write("#{@outfile}.png")
  end

  private
  def formulate_labels labels
    formated_labels = labels.map do |label|
      if label == labels.first || label == labels.last
        label
      else
        ""
      end
    end
    Hash[(0..labels.size).zip formated_labels]
  end
end
