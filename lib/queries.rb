require 'sqlite3'

class Queries
  attr_reader :db

  def initialize(dbname = "releases")
    # connect to the database
    @db = SQLite3::Database.new "database/#{dbname}.db"
  end

  def count_releases
    # count the releases
    db.get_first_value "SELECT COUNT(*) FROM albums;"
  end

  def unique_artists
    db.get_first_value "SELECT COUNT(DISTINCT artist) FROM albums"
  end

  def oldest_release
    db.get_first_row <<-QUERY
      SELECT artist, title 
      FROM albums 
      WHERE released != 0 
      ORDER BY released ASC, artist LIMIT 1;
    QUERY

  end

  def most_recent
    db.get_first_row <<-QUERY
      SELECT artist, title
      FROM albums
      ORDER BY date_added DESC
      LIMIT 1;
    QUERY
  end

  def least_recent
    db.get_first_row <<-QUERY
      SELECT artist, title
      FROM albums
      ORDER BY date_added ASC
      LIMIT 1;
    QUERY
  end

  def added_in(year)
    query = <<-QUERY
      SELECT COUNT(*) FROM albums
      WHERE date_added LIKE ?;
    QUERY

    db.get_first_value(query, "#{year}-%")
  end

  def released_between(start_year, end_year)
    query = <<-QUERY
      SELECT COUNT(*) FROM albums
      WHERE released BETWEEN ? AND ?;
    QUERY

    db.get_first_value(query, start_year, end_year)
  end

  def artist_with_most_releases
    query = <<-QUERY
      SELECT artist, count(title) AS release_count
      FROM albums
      GROUP BY artist
      ORDER BY release_count DESC
      LIMIT 1;
    QUERY

    db.get_first_value(query)
  end

  def most_by_year
    query = <<-QUERY
      SELECT released, count(*) AS release_count
      FROM albums
      GROUP BY released
      ORDER BY release_count DESC
      LIMIT 1;
    QUERY

    db.get_first_row(query)
  end

  def years_missing(start_year, end_year)
    query = <<-QUERY
      SELECT DISTINCT released
      FROM albums;
    QUERY

    rows  = db.execute(query)
    years = rows.flatten
    (start_year..end_year).to_a - years
  end
end

query_object = Queries.new

puts "Bonus questions!"
# Which artist has the most albums in the collection?
puts "Bonus 1: #{ query_object.artist_with_most_releases } has the most releases."

# Which year has the most releases? How many albums were released in that year?
puts "Bonus 2: #{ query_object.most_by_year }"

# What years between 1960 and 2010 have zero releases?
puts "Bonus 3: #{ query_object.years_missing(1960, 2010) }"


# How many albums are in the collection?
puts "Answer 1: There are #{ query_object.count_releases } albums in the collection."

# How many unique artist entries are in the collection?
puts "Answer 2: There are #{ query_object.unique_artists } unique artist."

# What is the oldest (earliest release year) release in the database?
puts "Answer 3: #{ query_object.oldest_release }"

# Which album was most recently added to the collection?
puts "Answer 4: #{ query_object.most_recent }"

# What was the first album added to the collection?
puts "Answer 5: #{ query_object.least_recent }"

# How many albums were added to the collection in 2014?
puts "Answer 6: #{ query_object.added_in(2014) }"

# How many albums were released between 1970 and 1979?
puts "Answer 7: #{ query_object.released_between(1970, 1979) }"








