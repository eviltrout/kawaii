begin
  require 'aws/s3'

  AWS::S3::Base.establish_connection!(
      :access_key_id     => 'FILL_ME_IN',
      :secret_access_key => 'FILL_ME_IN'
  )

  KAWAII_OPTIONS = {
    :snippets_enabled => true,
    :bucket_name => "FILL_ME_IN",
    :password => 'CHANGE_ME'
  }
  
rescue Exception => ex
  KAWAII_OPTIONS = {
    :snippets_enabled => false,
    :password => 'CHANGE_ME'    
  }  
end

# Patch in a too_cute method to a bunch of things
class Object
  def too_cute
    {:type => 'string', :string => inspect}
  end
end

class ActiveRecord::Base
  def too_cute
    kawaii_columns = [{:key => 'Column'}, {:key => 'Value'}]
    data = []
    self.class.columns.each do |col|
      data << {"Column" => col.name, "Value" => self[col.name]}
    end
    
    {:type => 'grid', :columns => kawaii_columns, :data => data }
  end
  
  # Return our schema
  def self.too_cute
    # We're just a model, let's get our nice info!
    kawaii_columns = [{:key => 'Name'},
                      {:key => 'Type'},
                      {:key => 'Limit'},
                      {:key => 'Null'},
                      {:key => 'Default'},
                      {:key => 'Precision'},
                      {:key => 'Scale'}]
    
    data = []
    columns.each do |col|
      row = {}
      kawaii_columns.each do |col2|
        row[col2[:key]] = col.send(col2[:key].downcase)
      end
      data << row
    end
    
    {:type => 'grid', :columns => kawaii_columns, :data => data }
  end
end

class Array
  
  MAX_ROWS_KAWAII = 25
    
  def too_cute
    # Let's be a little cheeky and see if every element is an ActiveRecord.
    all_activerecords = true
    each do |row|
      next if row.kind_of?(ActiveRecord::Base)
      all_activerecords = false
      break
    end
    
    if all_activerecords
      {:type => 'grid', 
       :columns => first.class.columns.collect {|c| {:key => c.name}},
       :data => self[0..MAX_ROWS_KAWAII]}
    else
      super
    end
  end
end

