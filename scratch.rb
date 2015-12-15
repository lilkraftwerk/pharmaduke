require_relative 'report_line'

10.times do 
  t = TripReport.new
  puts t.random_line
  puts "*" * 20
end