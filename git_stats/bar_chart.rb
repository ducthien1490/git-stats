class BarChart
  attr_reader :title
  attr_reader :lables
  attr_reader :data_sets
  attr_reader :outfile

  def initialize(title, labels,  data_sets, outfile)
    @title = title
    @labels = labels
    @data_sets = data_sets
    @outfile = outfile
  end

  def export_file
    g = Gruff::Bar.new
    g.title = @title
    g.labels = formulate_labels @labels
    formulate_data(@data_sets).each do |data|
      g.data data[:name].to_sym, data[:value]
    end
    g.write("#{@outfile}_barchart.png")
  end

  private
  def formulate_data data
    datasets = []
    datasets << {name: "Added", value: data.collect{|f| f.lines_added}}
    datasets << {name: "Deleted", value: data.collect{|f| f.lines_removed}}
    datasets
  end

  def formulate_labels labels
    Hash[(0..labels.size).zip labels]
  end
end
