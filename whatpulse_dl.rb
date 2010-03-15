#!/usr/bin/ruby

UserID = 289934

require 'open-uri'
File.open(File.join(ENV['HOME'], "whatpulse_stats.xml"), "w") do |wpf|
    open("http://whatpulse.org/api/user.php?UserID=#{UserID}") do |f|
        f.each_line do |line|
            wpf.puts line
        end
    end
end
