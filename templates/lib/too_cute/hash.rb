class Hash
  
  def too_cute
    
    # Call super if we're empty
    return super if empty?
    
    # Format a hash as a grid with key, value
    {:type => 'grid',
     :columns => [{:key => 'Key'}, {:key => 'Value'}],
     :data => to_a.collect {|r| {'Key' => r[0].inspect, 'Value' => r[1].inspect} } }
     
  end
end