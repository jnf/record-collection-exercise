require 'sqlite3'

class ReleaseDatabase
  attr_reader :db

  def initialize(dbname = "releases")
    @db = SQLite3::Database.new "database/#{dbname}.db"
  end
end

release_db = ReleaseDatabase.new
