require 'io/console'
require 'signet/oauth_2/client'
require 'google/apis/calendar_v3'

print "type your client id: "
client_id=STDIN.noecho(&:gets).chomp

print "\ntype your client_secret: "
client_secret=STDIN.noecho(&:gets).chomp

print "\ntype your access token: "
access_token=STDIN.noecho(&:gets).chomp

print "\ntype your refresh_token token: "
refresh_token=STDIN.noecho(&:gets).chomp

print "\ntype your calendar id: "
calendar_id=STDIN.noecho(&:gets).chomp

authorization = Signet::OAuth2::Client.new(
  client_id: client_id,
  client_secret: client_secret,
  access_token: access_token,
  refresh_token: refresh_token,
  token_credential_uri: 'https://accounts.google.com/o/oauth2/token',
  scope: 'https://www.googleapis.com/auth/calendar',
)
authorization.refresh!

service = Google::Apis::CalendarV3::CalendarService.new
service.authorization = authorization

print "\n\n## start to create leap roads ##\n\n"

current_year = Date.today.year
current_year.upto(current_year + 100) do |future_year|

  # うるう年以外は無視
  next future_year unless Date.valid_date?(future_year, 2, 29)

  event = {
    summary: 'うるう年を忘れるな！',
    start: {
      date_time: DateTime.new(future_year, 1, 1, 0, 0, 0, "+09:00:00").to_s,
    },
    end: {
      date_time: DateTime.new(future_year, 2, 29, 23, 59, 59, "+09:00:00").to_s,
    }
  }
  
  event = Google::Apis::CalendarV3::Event.new(event)
  service.insert_event(calendar_id, event)

  print "create #{future_year}'s leap road!\n"
end

