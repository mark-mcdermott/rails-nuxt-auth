class CreatePublicData < ActiveRecord::Migration[7.0]
  def change
    create_table :public_data do |t|
      t.string :datum

      t.timestamps
    end
  end
end
