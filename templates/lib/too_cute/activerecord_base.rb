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