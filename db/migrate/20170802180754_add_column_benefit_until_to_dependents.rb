class AddColumnBenefitUntilToDependents < ActiveRecord::Migration[5.0]
  def change
    add_column :dependents, :benefit_until, :date
  end
end
