class CreateInfos < ActiveRecord::Migration
  def change
    create_table :infos do |t|
      t.string :url
      t.string :title
      t.string :desc
      t.references :term, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
