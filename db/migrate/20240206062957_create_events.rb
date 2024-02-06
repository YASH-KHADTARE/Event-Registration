class CreateEvents < ActiveRecord::Migration[7.1]
  def change
    create_table :events do |t|
      t.string :title
      t.date :publish_date
      t.string :time
      t.string :venue
      t.text :description
      t.string :status

      t.timestamps
    end
  end
end
