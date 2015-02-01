class SimpleCov::Formatter::Min < SimpleCov::Formatter::HTMLFormatter

  def output_message(result)
    puts "\n#{result.command_name} - Coverage: #{result.covered_lines} / " +
      "#{result.total_lines} LOC (#{result.covered_percent.round(2)}%)"
  end

end