class AddWeightToInfos < ActiveRecord::Migration
  def change
    add_column :infos, :weight, :decimal,:default => 0
  end
end
