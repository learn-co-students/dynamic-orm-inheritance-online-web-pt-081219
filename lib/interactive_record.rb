# this is the parent class
#its flexible for any class to inherit from it because no date is explicitly given. 
#line require 'active_support/inflector' is a gem needed for .pluralize to pluralize the table names 
#pragma is  used to turn arrays into hashes?
#are all attr_accessor called "name" when used in the table_info code? like how do we fine that info first to write the code?
#if interpolating is a security risk are we ever gonna write codce this way? i know we are doing it to be more dynamic but is there a way to secure it more doing it this way?


require_relative "../config/environment.rb"
require 'active_support/inflector'

class InteractiveRecord

  def self.table_name
    self.to_s.downcase.pluralize
  end

  def self.column_names
    DB[:conn].results_as_hash = true

    sql = "pragma table_info('#{table_name}')"

    table_info = DB[:conn].execute(sql)
    column_names = []
    table_info.each do |row|
      column_names << row["name"]
    end
    column_names.compact #.compact gets rid of nil
  end

  def initialize(options={})
    options.each do |property, value|
      self.send("#{property}=", value) #ex: @name = name
    end
  end

  def save
    sql = "INSERT INTO #{table_name_for_insert} (#{col_names_for_insert}) VALUES (#{values_for_insert})"
    DB[:conn].execute(sql)
    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM #{table_name_for_insert}")[0][0]
  end

  def table_name_for_insert
    self.class.table_name
  end

  def values_for_insert
    values = []
    self.class.column_names.each do |col_name|
      values << "'#{send(col_name)}'" unless send(col_name).nil?
    end
    values.join(", ")
  end

  def col_names_for_insert
    self.class.column_names.delete_if {|col| col == "id"}.join(", ") #ex: attr_accessor.. "name, album" taking the id out
  end

def self.find_by_name(name)
  sql = "SELECT * FROM #{self.table_name} WHERE name = ?"
  DB[:conn].execute(sql, name)
end

end
