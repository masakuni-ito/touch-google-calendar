require 'json'
require 'net/https'
require 'cgi'
require 'cgi/session'

cgi = CGI.new
session = CGI::Session.new(cgi)

params = {
  :client_id => session['client_id'],
  :client_secret => session['client_secret'],
  :redirect_uri => 'http://localhost:8000/authorize',
  :grant_type => 'authorization_code',
  :code => cgi.params['code'].first.to_s,
}
data = params.map { |k, v| [k, v.to_s.encode('utf-8')] }.to_h

http = Net::HTTP.new('accounts.google.com', 443)
http.use_ssl = true
req = Net::HTTP::Post.new('/o/oauth2/token')
req.set_form_data(data)

res = http.request(req)

raise "error: cannot get response." unless res.is_a?(Net::HTTPOK)

# show acces_code
res_json = JSON.parse(res.body)
cgi.out(:type => 'text/plain', :charset => 'UTF-8') {
  "access_token: #{res_json['access_token']}\nrefresh_token: #{res_json['refresh_token']}"
}

