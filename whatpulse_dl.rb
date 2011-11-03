#!/usr/bin/ruby

require './libgit_archive.rb'
UserID = 289934


download("http://whatpulse.org/api/user.php?UserID=#{UserID}", "whatpulse_stats.xml")
commit "Whatpulse stats update"
