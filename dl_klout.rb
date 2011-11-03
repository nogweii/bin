#!/usr/bin/ruby

require './libgit_archive.rb'

# Cron-Up API key
API_Key = "w4tvkac848b6qtq6dfjrv738"
# Comma separated list of users to get information about
Users = %w[evaryont].join(',')
# Urls for each API call.
ProfileUrl = "https://api.klout.com/1/users/show.xml?users=%s&key=%s" % [Users, API_Key]
InfluenceUrl = "https://api.klout.com/1/soi/influencer_of.xml?users=%s&key=%s" % [Users, API_Key]

download(ProfileUrl, "klout_profile.xml")
download(InfluenceUrl, "klout_influence.xml")
commit "Update klout information"
