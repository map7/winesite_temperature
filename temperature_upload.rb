#!/usr/bin/env ruby
#
# EG: http://mechanize.rubyforge.org/GUIDE_rdoc.html

# Use mechanize to login and give me access to posting data on the site.
require 'mechanize'

# Change details to suit
HOST="http://localhost:3000"
CELLAR_ID="3"

# Setup Mechanize
agent = Mechanize.new
page =agent.get('http://localhost:3000/users/sign_in')

# Get user details
begin
  string = IO.read("#{ENV['HOME']}/.winesite")
rescue
  puts "Please create #{ENV['HOME']}/.winesite as a json file with email & password"
  exit
end

# Convert the file into a JSON object which we can easily read
json=JSON.parse(string)

# Login to my winesite
login_form = page.form("login")
login_form.field_with(type: "email").value = json["email"]
login_form.field_with(type: "password").value = json["password"]
page = agent.submit(login_form)

# page = agent.get("#{HOST}/wines.json")
# pp page.body

params = {
          temperature: {
            cellar_id: CELLAR_ID,
            date: Time.now,
            temperature: 25,
            humidity: 20
          }
         }
headers = { 'Content-Type' => 'application/json', 'Accept' => 'application/json'}
#agent.post("#{HOST}/temperatures.json", '{"temperature":{"temperature": "29"}}', headers)
agent.post("#{HOST}/temperatures.json", params.to_json, headers)
