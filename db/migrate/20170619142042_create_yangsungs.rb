class CreateYangsungs < ActiveRecord::Migration[5.1]
  def change
    create_table :yangsungs do |t|
      t.string :morning
      t.string :lunch
      t.string :dinner

      t.timestamps
    end
  end
end
