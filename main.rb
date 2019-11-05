require_relative './lib/simulator'

# default
params = {
  lambda: 1.5,
  mu: 2.0,
  t_r: 0.4,
}

unless ARGV[0] == '-d'
  print 'Enter λ  : '
  params[:lambda] = gets.to_f

  print 'Enter μ  : '
  params[:mu] = gets.to_f

  print 'Enter Тр : '
  params[:t_r] = gets.to_f
end

simulator = Simulator.new(**params)

characteristics = simulator.simulate

puts """
  Lс: #{characteristics[:average_count_in_system]}
  Lоч: #{characteristics[:average_count_in_queue]}
  Wс: #{characteristics[:average_time_in_system]}
  Wоч: #{characteristics[:average_time_in_queue]}
"""
