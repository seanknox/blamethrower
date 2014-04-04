#!/usr/bin/env ruby
require 'json'

start_time = Time.now

class String

  # colorization
  def colorize(color_code)
    "\e[#{color_code}m#{self}\e[0m"
  end

  def red
    colorize(31)
  end

  def green
    colorize(32)
  end

  def yellow
    colorize(33)
  end
end

files = `git ls-tree -r HEAD #{ARGV.join(" ")}| cut -f 2`

@queue     = []
@results   = []
pool_size  = 10

counthash  = Hash.new{0}

def enqueue file_name, &block
  @queue << [block, file_name]
end

def perform
  read, write = IO.pipe

  pid = fork do
    read.close
    result = yield
    Marshal.dump(result, write)
    exit!(0)
  end

  write.close
  @results << read
end

# Enqueue the jobs
files.lines.each do |f|

  enqueue(f) do |file|
    counthash = Hash.new{0}

    filecount = `git blame --line-porcelain #{file.chomp} | grep \"author \" |sort|uniq -c |sort -nr`.lines
    filecount.each do |line|
      begin
        p file
        matchdata = line.match /(\d+)\s+author\s+(.*)/
        author    = matchdata[2]
        linecount = matchdata[1].to_i

        counthash[author] += linecount
        print ".".green

      rescue
        print ".".red
      end

    end

    counthash.to_json
  end
end

# Map the work
loop do
  break if @queue.empty?

  slice = pool_size.times.each do
    job, args = @queue.pop
    perform do
      job.call(*args)
    end if job
  end

  Process.waitall
end

# Reduce the results
@results.each do |reader|
  sub_count = JSON.parse Marshal.load(reader.read)
  sub_count.each do |name, count|
    counthash[name] += count
  end
end

sorted_array = counthash.sort_by {|k,v| -v.to_i}

puts '!'
puts "Elapsed Time: #{Time.now - start_time}"
puts "Contributors:"
sorted_array.each do |author,lines|
  puts "#{author}".red + ": " + "#{lines}".yellow
end