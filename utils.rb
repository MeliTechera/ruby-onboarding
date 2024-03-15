# frozen_string_literal: true

TRELLO_URL = 'https://api.trello.com/1/'
APIKEY = ''
APITOKEN = ''

def create_list(decade, board_id)
  url = "#{TRELLO_URL}lists?name=#{decade}&idBoard=#{board_id}&key=#{APIKEY}&token=#{APITOKEN}"
  post(url)
end

def create_card(album_name, id_list)
  url = "#{TRELLO_URL}cards?idList=#{id_list}&name=#{album_name}&key=#{APIKEY}&token=#{APITOKEN}"
  post(url)
end

def create_board(name)
  url = "#{TRELLO_URL}boards/?name=#{name}&key=#{APIKEY}&token=#{APITOKEN}"
  post(url)
end

def fetch(uri_str)
  response = Net::HTTP.get_response(URI(uri_str))

  case response
  when Net::HTTPSuccess
    puts 'Request was successful:'
    puts response.body
  else
    puts "Request failed with code: #{response.code}"
    puts response.message
  end
rescue SocketError => e
  puts "Error connecting to the server: #{e.message}"
rescue Timeout::Error
  puts 'Request timed out'
rescue StandardError => e
  puts "An unexpected error occurred: #{e.message}"
end

def post(uri_str)
  uri = URI.parse(URI::Parser.new.escape(uri_str))
  http = Net::HTTP.new(uri.host, uri.port)
  # http.use_ssl = true if uri.scheme == 'https'
  request = Net::HTTP::Post.new(uri.request_uri)
  begin
    response = http.request(request)
    case response
    when Net::HTTPSuccess
      JSON.parse(response.body)
    else
      puts "Request failed with code: #{response.code}"
      puts response.message
    end
  rescue SocketError => e
    puts "Error connecting to the server: #{e.message}"
  rescue Timeout::Error
    puts 'Request timed out'
  rescue StandardError => e
    puts "An unexpected error occurred: #{e.message}"
  end
end
