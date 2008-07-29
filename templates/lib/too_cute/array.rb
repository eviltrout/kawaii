class Array
  
  MAX_ROWS_KAWAII = 25
    
  def too_cute
    
    # Call super if we're empty
    return super if empty?
    
    # Let's be a little cheeky and see if every element is an ActiveRecord.
    all_activerecords = true
    
    each do |row|
      next if row.kind_of?(ActiveRecord::Base)
      all_activerecords = false
      break
    end
    
    if all_activerecords
      columns = first.class.columns.collect {|c| {:key => c.name}}
      
      # Make our own hash, otherwise the json call will put "record_name" => values
      # instead of just the values we want for our column
      data = self[0..MAX_ROWS_KAWAII].collect do |r|
        row = {}
        columns.each {|c| row[c[:key]] = r[c[:key]] }
        row
      end
      
      {:type => 'grid', 
       :columns => columns,
       :data => data}
    else
      # If it's not an array of activerecords
      {:type => 'grid',
       :columns => [{:key => 'Value'}],
       :data => self[0..MAX_ROWS_KAWAII].collect {|r| {'Value' => r.inspect} } }
    end
    
  end
end