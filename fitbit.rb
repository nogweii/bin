require 'fitgem'
require 'yaml'

require './libgit_archive.rb'

fitbit_info = YAML.load_file 'fitbit.login.yml'
consumer_key = fitbit_info['consumer_key']
consumer_secret = fitbit_info['consumer_secret']
token = fitbit_info['auth_token']
secret = fitbit_info['auth_secret']
user_id = fitbit_info['userid']

client = Fitgem::Client.new({:consumer_key => consumer_key, :consumer_secret => consumer_secret, :token => token, :secret => secret, :user_id => user_id})
access_token = client.reconnect(token, secret)
final = client.user_info
final["goals"] = {}
final["summary"] = {}

t = Time.now

# Get information about all the aspects fitbit tracks

# Activities: Steps, how hard each was, distance, etc..
activities_today = client.activities_on_date('today')
final["goals"] = activities_today["goals"]
final["summary"] = activities_today["summary"]
final["activities"] = activities_today["activities"]

# Body measurements. Metric units.
body_today = client.body_measurements_on_date(t)
final["goals"] = final["goals"].merge(body_today["goals"]) if body_today["goals"]
final["summary"] = final["summary"].merge(body_today["summary"]) if body_today["summary"]
final["body"] = body_today["body"]

# Sleep cycle information
sleep_today = client.sleep_on_date(t)
final["goals"] = final["goals"].merge(sleep_today["goals"]) if sleep_today["goals"]
final["summary"] = final["summary"].merge(sleep_today["summary"]) if sleep_today["summary"]
final["sleep"] = sleep_today["body"]

# Recent diet. Calorie counts (estimated)
recent_foods = client.foods_on_date(t)
final["goals"] = final["goals"].merge(recent_foods["goals"]) if recent_foods["goals"]
final["summary"] = final["summary"].merge(recent_foods["summary"]) if recent_foods["summary"]
final["foods"] = recent_foods["body"]

File.open('fitbit.yml', 'w') do |fitbit_file|
    fitbit_file.puts(final.to_yaml)
end

@repo.add 'fitbit.yml'
commit 'Updated Fitbit YAML'
