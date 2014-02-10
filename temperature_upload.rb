#!/usr/bin/env ruby
#
# EG: http://mechanize.rubyforge.org/GUIDE_rdoc.html

require 'mechanize'

# Setup Mechanize
agent = Mechanize.new
page =agent.get('http://localhost:3000/users/sign_in')

# Get user details
string = IO.read("/home/map7/.winesite")
json=JSON.parse(string)

# Login to my winesite
login_form = page.form("login")
login_form.field_with(type: "email").value = json["username"]
login_form.field_with(type: "password").value = json["password"]
page = agent.submit(login_form)


page = agent.get("http://localhost:3000/wines.json")
pp page.body

