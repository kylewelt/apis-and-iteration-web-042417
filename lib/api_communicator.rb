require 'rest-client'
require 'json'
require 'pry'

def get_character_movies_from_api(character)
  # make the web request
  all_characters = RestClient.get('http://www.swapi.co/api/people/')
  character_hash = JSON.parse(all_characters)

  character_films = {}
  # iterate over the character hash to find the collection of `films` for the given
  #  `character`
  character_hash["results"].each do |person|
    if person["name"].downcase == character
      character_films = person["films"]
    end
  end

  character_films
end

def get_film_details_from_api(films_hash)
  # collect those film API urls, make a web request to each URL to get the info
  #  for that film
  character_films_array = []

  films_hash.map do |film_url|
    # make the web request
    all_film_details = RestClient.get(film_url)
    film_details_hash = JSON.parse(all_film_details)
    # push the API response to our films array
    character_films_array << film_details_hash
  end

  # return value of this method should be collection of info about each film.
  #  i.e. an array of hashes in which each hash reps a given film
  # this collection will be the argument given to `parse_character_movies`
  #  and that method will do some nice presentation stuff: puts out a list
  #  of movies by title. play around with puts out other info about a given film.
  character_films_array
end

def parse_character_movies(films_hash)
  # some iteration magic and puts out the movies in a nice list
  if !(films_hash.empty?)
    films_hash.each.with_index(1) do |film, index|
      puts "#{index} #{film["title"]}"
    end
  else
    puts "Character not found."
  end
end

def show_character_movies(character)
  films_hash = get_character_movies_from_api(character)
  films_details_hash = get_film_details_from_api(films_hash)
  parse_character_movies(films_details_hash)
end

## BONUS

# that `get_character_movies_from_api` method is probably pretty long. Does it do more than one job?
# can you split it up into helper methods?
