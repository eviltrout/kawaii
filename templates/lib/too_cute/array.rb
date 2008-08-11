class Array
    
  def too_cute
    
    # Call super if we're empty
    return super if empty?

    # Let's see if everything in the array is the same
    all_same = true
    contained_class = first.class
    array_columns = []
    each do |row|
      
      # If we have hashes in our array, remember their columns for later
      if row.is_a?(Hash)
        row.keys.each {|c| array_columns << c}
        array_columns.uniq!
      end
      
      next if row.is_a?(contained_class)
      all_same = false
      break
    end

    return super unless all_same
        
    if first.kind_of?(ActiveRecord::Base)
      build_grid(first.class.columns.collect {|c| {:key => c.name}})
    elsif first.kind_of?(Hash)
      build_grid(array_columns.collect {|c| {:key => c}})
    else
      # If it's not an array of activerecords
      {:type => 'grid',
       :columns => [{:key => 'Value'}],
       :data => collect {|r| {'Value' => r.inspect} } }
    end
  end
  
  def build_grid(grid_columns)
    # Make our own hash, otherwise the json call will put "record_name" => values
    # instead of just the values we want for our column
    data = collect do |r|
      row = {}
      grid_columns.each {|c| row[c[:key]] = r[c[:key]] }
      row
    end
    
    {:type => 'grid', :columns => grid_columns, :data => data}    
  end
  
end