class CreateKawaiiSnippets < ActiveRecord::Migration
  def self.up
    create_table :kawaii_snippets do |t|
      t.string      :key, :limit => 50
      t.text        :value
    end
  end

  def self.down
    drop_table :kawaii_snippets
  end
end
