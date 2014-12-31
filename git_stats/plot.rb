class Plot
  attr_accessor :set
  attr_accessor :outfile
  attr_accessor :title
  attr_accessor :xlabel
  attr_accessor :ylabel

  def initialize(sets, outfile, title, xlabel, ylabel)
    @sets = sets
    @outfile = outfile
    @title = title
    @xlabel = xlabel
    @ylabel = ylabel
  end

  def plot
    sets = []
    @sets.each do |s|
      sets << Gnuplot::DataSet.new(generate_vals(s)) { |ds|
        ds.with = 'lines'
        ds.linewidth = 1
      }
    end
    write_plot(sets)
  end

  private
  def generate_vals(set)
    return set[:x_val], set[:y_val]
  end

  def write_plot(sets)
    Gnuplot.open do |gp|
      Gnuplot::Plot.new(gp) do |plot|
        plot.terminal 'png'
        plot.size '2.0,2.0'
        plot.data = sets
        plot.xrange "[#{sets.first.data.first.first}:#{sets.first.data.first.last}]"
        max_y = [sets.first.data.last.max, sets.last.data.last.max].max
        plot.yrange "[0:#{max_y}]"
        plot.output File.join("../", @outfile + '.png')
        plot.title @title
        plot.ylabel @ylabel
        plot.xlabel @xlabel
      end
    end
  end
end
