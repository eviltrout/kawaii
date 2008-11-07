class KawaiiSnippet < ActiveRecord::Base

  validates_uniqueness_of :key

  def delete
    destroy
  end

end
