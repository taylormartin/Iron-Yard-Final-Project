class CreateCity < ActiveRecord::Migration
  def change
    create_table :cities do |t|
      t.string     :name
      t.integer    :metro_area_id
      t.datetime   :created_at
      t.datetime   :updated_at
      t.timestamps
    end
  end
end
