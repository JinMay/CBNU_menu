class CreateMains < ActiveRecord::Migration[5.1]
  def change
    create_table :mains do |t|
      t.string :morning
      t.string :lunch
      t.string :dinner

      t.timestamps
    end
  end
end
