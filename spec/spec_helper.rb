require "bundler/setup"
require "waveguide"
require "benchmark"
require "ruby-prof"
require "active_model_serializers"

["fixtures", "helpers"].each do |support_path|
  pattern = File.join(File.dirname(__FILE__), support_path, "**", "*.rb")
  Dir[pattern].each {|f| require f}
end

RSpec.configure do |config|
  config.example_status_persistence_file_path = ".rspec_status"
  config.disable_monkey_patching!

  config.include BenchmarkHelper

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.before(:suite) do
    $benchmarks = {}
    $profiles = {}
  end

  config.after(:suite) do
    puts "\n\nBenchmark Results:"
    $benchmarks.sort.reverse.each do |benchmark_name, result|
      millis = (result * 1000).round(2)
      puts "  " + benchmark_name.ljust(40) + ": #{millis} ms"
    end

    puts "\n\nProfile Results:"
    $profiles.each do |profile_name, profile|
      puts "  " + profile_name + ":"
      printer = RubyProf::FlatPrinter.new(profile)
      output = StringIO.new
      printer.print(output, :min_percent => 1)

      output = output.string.lines.slice(6..-2)
      output.each do |line|
        print "    " + line
      end
    end

    puts "\n\nFasterer recommendations:"
    puts `fasterer`
  end
end
