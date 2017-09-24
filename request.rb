require 'json'
require 'net/https'
require 'cgi'
require 'cgi/session'

SCOPE='https://www.googleapis.com/auth/calendar'
REDIRECT_URI='http://localhost:8000/authorize'

# パラメタからクライアント情報を取得する
cgi =  CGI.new
client_id = cgi.params['client_id'].first.to_s
client_secret = cgi.params['client_secret'].first.to_s

# authorize.rbの方でも使うのでセッションに入れておく
session = CGI::Session.new(cgi)
session['client_id'] = client_id
session['client_secret'] = client_secret

# 認可のためのリダイレクト
link = URI.escape("https://accounts.google.com/o/oauth2/auth?client_id=#{client_id}&redirect_uri=#{REDIRECT_URI}&response_type=code&scope=#{SCOPE}&access_type=offline&approval_prompt=force")
print cgi.header({ 
  "status"     => "REDIRECT",
  "Location"   => link
})

