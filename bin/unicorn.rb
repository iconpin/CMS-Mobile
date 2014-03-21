#!/usr/bin/env ruby

unicorn_file_path = File.expand_path(File.join(File.dirname(__FILE__), '../unicorn.rb'))
pids_file_path = File.expand_path(File.join(File.dirname(__FILE__), '../tmp/pids/unicorn.pid'))
stderr_file_path = File.expand_path(File.join(File.dirname(__FILE__), '../log/unicorn.stderr.log'))
stdout_file_path = File.expand_path(File.join(File.dirname(__FILE__), '../log/unicorn.stdout.log'))

case ARGV[0]
when 'start'
  Kernel.system("unicorn -c #{unicorn_file_path} -D")
when 'stop'
  Kernel.system("cat #{pids_file_path} | xargs kill -KILL")
when 'stderr'
  Kernel.exec("tail -f #{stderr_file_path}")
when 'stdout'
  Kernel.exec("tail -f #{stdout_file_path}")
when 'pid'
  Kernel.exec("cat #{pids_file_path}")
else
  puts "Usage: bin/unicorn.rb start|stop|stderr|stdout|pid"
end
