# By default we just want to do a select_all to get back a result set as an array of hashes.
# This sucks a little because the column order is not preserved.
module ActiveRecord
  module ConnectionAdapters
    class AbstractAdapter
      def db_too_cute(sql)
        select_all(sql)
      end
    end
  end
end

# For Mysql, we'll do an execute to get back a Mysql::Result, which has a too_cute method
# that will preserve column order
module ActiveRecord
  module ConnectionAdapters
    class MysqlAdapter
      def db_too_cute(sql)
        execute(sql)
      end
    end
  end
end

begin
  # We need mysql for the following code
  if ActiveRecord::Base.respond_to?(:require_mysql)
    ActiveRecord::Base.require_mysql
    class Mysql
      class Result
        def too_cute
          columns = []
          fetch_fields.each {|f| columns << {:key => f.name}}

          data = []  
          each_hash {|r| data << r }
      
          {:type => 'grid', :columns => columns, :data => data}
        end
      end
    end
  end
rescue LoadError
  # If we don't have MySQL, that's fine. Do nothing.
end