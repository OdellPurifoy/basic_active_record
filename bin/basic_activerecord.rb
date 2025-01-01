#!/usr/bin/env ruby
#
require_relative '../lib/basic_activerecord'

BasicActiveRecord::DatabaseConnection.instance.execute(<<-SQL)
  CREATE TABLE IF NOT EXISTS users (
    id INTEGER PRIMARY KEY,
    name TEXT,
    organization TEXT,
    active BOOLEAN,
    created_at DATETIME
  );
SQL

BasicActiveRecord::DatabaseConnection.instance.execute("INSERT INTO users (name, organization, active, created_at) VALUES ('John Doe', 'Acme', 1, '2018-01-01')")
BasicActiveRecord::DatabaseConnection.instance.execute("INSERT INTO users (name, organization, active, created_at) VALUES ('Jane Doe', 'Acme', 1, '2018-01-01')")
BasicActiveRecord::DatabaseConnection.instance.execute("INSERT INTO users (name, organization, active, created_at) VALUES ('John Smith', 'Acme', 0, '2018-01-01')")

class User < BasicActiveRecord::Base
  def self.active
    where(active: 1)
  end

  def self.recent
    order(created_at: :asc)
  end
end

puts User.where(organization: 'Acme').active.recent.count
puts User.active.where(organization: 'Acme').recent.to_a