class CreateCrjs < ActiveRecord::Migration[5.1]
  def change
    create_table :crjs do |t|
      t.string :morning
      t.string :lunch
      t.string :dinner

      t.timestamps
    end
  end
end
