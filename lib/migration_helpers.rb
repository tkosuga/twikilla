module MigrationHelpers
  
  def primary_key(table, column)
    execute %{alter table #{table} add primary key (#{column})}
  end
  
  def foreign_key(from_table, from_column, to_table)
    constraint_name = "fk_#{from_table}_#{from_column}" 
    
    execute %{alter table #{from_table}
              add constraint #{constraint_name}
              foreign key (#{from_column})
              references #{to_table}(id)}
  end
end

class ActiveRecord::ConnectionAdapters::PostgreSQLAdapter
  def native_database_types
    {
      :primary_key => "bigserial primary key",
      :string      => { :name => "character varying", :limit => 255 },
      :text        => { :name => "text" },
      :integer     => { :name => "integer" },
      :float       => { :name => "float" },
      :datetime    => { :name => "timestamp" },
      :timestamp   => { :name => "timestamp" },
      :time        => { :name => "time" },
      :date        => { :name => "date" },
      :binary      => { :name => "bytea" },
      :boolean     => { :name => "boolean" },
      :bigint      => { :name => "int8" }
    }
  end
end