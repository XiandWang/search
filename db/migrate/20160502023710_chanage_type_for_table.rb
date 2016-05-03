class ChanageTypeForTable < ActiveRecord::Migration
  def change
  	    change_column :infos, :desc, :text
  	    change_column :infos, :url, :text
  	    change_column :infos, :title, :text
  	    change_column :terms, :name, :text
  end
end
