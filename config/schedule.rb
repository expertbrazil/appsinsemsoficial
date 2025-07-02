### whenever --update-crontab

every :day, :at => '05:00am' do
  runner "Dependent.inactive_benefit_expired"
end

every :day, :at => '05:30am' do
  runner "BillsReceife.check_due_date_to_change_overdued"
end

every :day, :at => '05:40am' do
  runner "BillsPay.check_due_date_to_change_overdued"
end
