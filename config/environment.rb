require 'sqlite3'


DB = {:conn => SQLite3::Database.new("db/songs.db")}
DB[:conn].execute("DROP TABLE IF EXISTS songs")
sql = <<-SQL
  CREATE TABLE IF NOT EXISTS songs (
  id INTEGER PRIMARY KEY,
  name TEXT,
  album TEXT
  )
SQL

DB[:conn].execute(sql)
DB[:conn].results_as_hash = true

#if it's supposed to be felixible why is songs here which is the child class. and what if we had other tables with more attributes besides name and album?

#   DB[:conn].results_as_hash = true... is a method that will take that nested array and turn it into a hash...key with value pair 