class CreateEvents < ActiveRecord::Migration[7.1]
  def change
    create_table :events do |t|
      t.string :name
      t.string :level
      t.datetime :starts_at

      t.timestamps
    end
  end
end
