#!/usr/bin/env ruby
#
# EG: http://mechanize.rubyforge.org/GUIDE_rdoc.html

# Use mechanize to login and give me access to posting data on the site.
require 'mechanize'

# Setup Mechanize
@agent = Mechanize.new

# Get user details
def get_user_details
  begin
    string = IO.read("#{ENV['HOME']}/.winesite")
  rescue
    puts "Please create #{ENV['HOME']}/.winesite as a json file with email & password"
    exit
  end

  # Convert the file into a JSON object which we can easily read
  json=JSON.parse(string)
  json
end

# Login to the remote site
def login(settings)
  page =@agent.get("#{settings['url']}/users/sign_in")

  # Login to my winesite
  login_form = page.form("login")
  login_form.field_with(type: "email").value = settings["email"]
  login_form.field_with(type: "password").value = settings["password"]
  page = @agent.submit(login_form)
end

settings = get_user_details
login(settings)

# page = @agent.get("#{settings['url']}/wines.json")
# pp page.body

params = {
          temperature: {
            cellar_id: settings["cellar"],
            date: Time.now,
            temperature: 20,
            humidity: 20
          }
         }
headers = { 'Content-Type' => 'application/json', 'Accept' => 'application/json'}

#@agent.post("#{settings['url']}/temperatures.json", '{"temperature":{"temperature": "29"}}', headers)
@agent.post("#{settings['url']}/temperatures.json", params.to_json, headers)
