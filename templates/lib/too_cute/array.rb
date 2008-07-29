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
    
    if all_activerecords and !empty?
      {:type => 'grid', 
       :columns => first.class.columns.collect {|c| {:key => c.name}},
       :data => self[0..MAX_ROWS_KAWAII]}
    else
      super
    end
  end
end