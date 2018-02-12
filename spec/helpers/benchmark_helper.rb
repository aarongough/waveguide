module BenchmarkHelper
  def benchmark(name, &block)
    results = 5.times.map do
      GC.disable
      result = Benchmark.realtime do
        block.call
      end
      GC.enable

      result
    end

    results = results.slice(2..-1)
    average = results.reduce(:+) / results.size.to_f
    $benchmarks[name] = average
  end
end 