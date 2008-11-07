class KawaiiSnippets
  
  def objects
    KawaiiSnippet.find(:all)
  end
  
  def [](key)
    KawaiiSnippet.find_by_key(key)
  end
  
end