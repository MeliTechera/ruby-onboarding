# frozen_string_literal: true

require './utils'

def fetch_albums
  File.readlines('discography.txt').map(&:chomp)
end

def get_albums_by_decade(albums)
  result = {}
  albums.each do |album|
    year = album[0..2].to_i * 10
    next if album.nil?

    if result[year].nil?
      result[year] = [album]
    else
      result[year] << album
    end
  end
  result
end

def create_list_and_cards(decade, albums, board_id)
  list = create_list(decade, board_id)
  if list.nil?
    puts "List #{decade} couldn't be created"
    return
  end
  albums.each do |album|
    create_card(album, list['id'])
  end
end

all_albums = fetch_albums.sort

albums_by_decade = get_albums_by_decade(all_albums)

board = create_board(ARGV[0].nil? ? "Bob Dylan's discography" : ARGV[0])
if board.nil?
  puts "Board couldn't be created"
  exit
end

albums_by_decade.each do |decade, albums|
  sorted_albums = albums.sort
  create_list_and_cards(decade, sorted_albums, board['id'])
end

puts 'Board created successfully'
