#!/usr/bin/env ruby

require 'net/http'
require 'net/https'
require 'open-uri'
require 'cgi'
require 'optparse'

ACCOUNT = 'colin.p.shea@gmail.com' # Set to Google Voice account email for default account
PASSWORD = 'jdpmtkfacjoojkkh' # Set to Google Voice account password for default account
NUMBERS = [] # Set one or more numbers for default destination(s)

options = {}
optparse = OptionParser.new do|opts|
  opts.banner = "Usage: voicesms.rb -n +15554443333[,+15554442222] -m \"Message to send\" [-u Username:Password]"

  options[:numbers] = NUMBERS
  opts.on( '-n', '--numbers NUM[,NUM]', 'Phone numbers to SMS (separate multiples with comma)' ) do|numbers|
    options[:numbers] = numbers.split(',')
  end

  options[:message] = false
  opts.on( '-m', '--message MESSAGE', 'Message to send' ) do|msg|
    options[:message] = msg
  end

   options[:username] = ACCOUNT
   options[:password] = PASSWORD
   opts.on( '-u', '--user USERNAME:PASSWORD', 'Google Voice username and password' ) do|creds|
     parts = creds.split(':')
     options[:username] = parts[0]
     options[:password] = parts[1]
   end

  opts.on( '-h', '--help', 'Display this screen' ) do
    puts opts
    exit
  end
end

optparse.parse!

unless options[:message]
  puts "Message required. Use -m \"MESSAGE\"."
  puts "Enter `voicesms.rb -h` for help."
  exit
end

def postit(uri_str, data, header = nil, limit = 3)
    raise ArgumentError, 'HTTP redirect too deep' if limit == 0
    url = URI.parse(uri_str)
    http = Net::HTTP.new(url.host,443)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    response,content = http.post(url.path,data,header)
    case response
      when Net::HTTPSuccess     then content
      when Net::HTTPRedirection then postit(response['location'],data,header, limit - 1)
      else
        puts response.inspect
        response.error!
    end
end

def getit(uri_str, header, limit = 3)
    raise ArgumentError, 'HTTP redirect too deep' if limit == 0
    url = URI.parse(uri_str)
    http = Net::HTTP.new(url.host,url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    response,content = http.get(url.path,header)
    case response
      when Net::HTTPSuccess     then content
      when Net::HTTPRedirection then getit(response['location'],header, limit - 1)
      else
        response.error!
    end
end

data = "accountType=GOOGLE&Email=#{options[:username]}&Passwd=#{options[:password]}&service=grandcentral&source=brettterpstra-CLISMS-2.0"
res = postit('https://www.google.com/accounts/ClientLogin',data)
if res
  authcode = res.match(/Auth=(.+)/)[1]
  header = {'Authorization' => "GoogleLogin auth=#{authcode.strip}",'Content-Length' => '0'}
  newres = getit('https://www.google.com/voice',header)
  if newres
    rnrse = CGI.escape(newres.match(/'_rnr_se': '([^']+)'/)[1])
    options[:numbers].each {|num|
      data = "_rnr_se=#{rnrse}&phoneNumber=#{num.strip}&text=#{CGI.escape(options[:message])}&id="
      finalres = postit('https://www.google.com/voice/sms/send/',data,header)
      if finalres["ok"]
        puts "Message sent to #{num}"
      else
        puts "Error sending to #{num}"
      end
    }
  else
    newres.error!
  end
else
  res.error!
end
