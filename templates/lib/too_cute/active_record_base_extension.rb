module TooCute
  module ActiveRecordBaseExtension
    def too_cute
      kawaii_columns = [{:key => 'Column'}, {:key => 'Value'}]
      data = []
      self.class.columns.each do |col|
        data << {"Column" => col.name, "Value" => self[col.name]}
      end
    
      {:type => 'grid', :columns => kawaii_columns, :data => data }
    end
  end
end