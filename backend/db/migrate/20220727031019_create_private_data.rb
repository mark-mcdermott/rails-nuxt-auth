class CreatePrivateData < ActiveRecord::Migration[7.0]
  def change
    create_table :private_data do |t|
      t.string :datum

      t.timestamps
    end
  end
end
