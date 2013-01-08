#!/usr/bin/env ruby 

files = `git ls-tree -r HEAD #{ARGV.join(" ")}| cut -f 2`

counthash = Hash.new {0}

files.lines.each do |file|
  puts "FILE: #{file}"
  filecount = `git blame --line-porcelain #{file.chomp} | grep \"author \" |sort|uniq -c |sort -nr`.lines

  filecount.each do |line|
    # Use rescue to handle errors from unprocesable files, like image files.
    begin 
    matchdata = line.match /(\d+)\s+author\s+(.*)/ 
    author = matchdata[2]  
    linecount = matchdata[1].to_i
    counthash[author] += linecount 
    rescue 
    end
  end

end

sorted_array = counthash.sort_by {|k,v| -v.to_i}

sorted_array.each {|author,lines| puts "#{author}: #{lines}" }

