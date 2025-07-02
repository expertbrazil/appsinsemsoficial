# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20240322134120) do

  create_table "appointbook_peopleassocis", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.integer  "appointment_book_id"
    t.integer  "people_associated_id"
    t.datetime "start_datetime"
    t.datetime "end_datetime"
    t.text     "situation",            limit: 65535
    t.datetime "created_at",                                         null: false
    t.datetime "updated_at",                                         null: false
    t.integer  "dependent_id"
    t.boolean  "confirmed"
    t.text     "observation",          limit: 65535
    t.boolean  "showed",                             default: false
    t.string   "sid"
    t.string   "token"
    t.boolean  "canceled",                           default: false
    t.boolean  "start_attendance",                   default: false
    t.boolean  "stop_attendance",                    default: false
    t.text     "description",          limit: 65535
    t.boolean  "has_return",                         default: false
    t.index ["appointment_book_id"], name: "index_appointbook_peopleassocis_on_appointment_book_id", using: :btree
    t.index ["people_associated_id"], name: "index_appointbook_peopleassocis_on_people_associated_id", using: :btree
  end

  create_table "appointment_books", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.integer  "professional_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["professional_id"], name: "index_appointment_books_on_professional_id", using: :btree
  end

  create_table "bank_accounts", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string   "name"
    t.string   "agency"
    t.string   "account_number"
    t.string   "cedente"
    t.string   "cedente_doc"
    t.string   "cedente_address"
    t.string   "variacao"
    t.string   "aceite",          default: "N"
    t.string   "carteira"
    t.string   "convenio"
    t.string   "instrucao_juros"
    t.boolean  "default_bank",    default: false
    t.integer  "layout"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  create_table "bills_pays", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.integer  "supplier_id"
    t.integer  "people_associated_id"
    t.integer  "payment_form_id"
    t.integer  "category_id"
    t.boolean  "payroll_discount"
    t.date     "due_date"
    t.text     "description",          limit: 65535
    t.decimal  "amount",                             precision: 10, scale: 2, default: "0.0"
    t.string   "n_doc"
    t.date     "competence_date"
    t.integer  "ocorrence",                                                   default: 0
    t.integer  "expiration_day"
    t.date     "deadline"
    t.boolean  "work_days_only",                                              default: false
    t.boolean  "receive",                                                     default: false
    t.date     "receive_date"
    t.boolean  "stop_recurrence",                                             default: false
    t.string   "state_assm"
    t.date     "next_in"
    t.datetime "created_at",                                                                  null: false
    t.datetime "updated_at",                                                                  null: false
    t.integer  "bank_account_id"
    t.index ["bank_account_id"], name: "index_bills_pays_on_bank_account_id", using: :btree
    t.index ["category_id"], name: "index_bills_pays_on_category_id", using: :btree
    t.index ["payment_form_id"], name: "index_bills_pays_on_payment_form_id", using: :btree
    t.index ["people_associated_id"], name: "index_bills_pays_on_people_associated_id", using: :btree
    t.index ["supplier_id"], name: "index_bills_pays_on_supplier_id", using: :btree
  end

  create_table "bills_receives", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.integer  "people_associated_id"
    t.integer  "category_id"
    t.integer  "financial_account_id"
    t.integer  "payment_form_id"
    t.date     "due_date"
    t.text     "description",          limit: 65535
    t.string   "state"
    t.decimal  "amount",                             precision: 10, scale: 2, default: "0.0"
    t.string   "n_doc"
    t.date     "competence_date"
    t.string   "attachment"
    t.integer  "ocorrence",                                                   default: 0
    t.date     "deadline"
    t.date     "next_in"
    t.string   "expiration_day"
    t.boolean  "work_days_only",                                              default: false
    t.boolean  "paid",                                                        default: false
    t.date     "paid_date"
    t.boolean  "stop_recurrence",                                             default: false
    t.datetime "created_at",                                                                  null: false
    t.datetime "updated_at",                                                                  null: false
    t.integer  "bills_pay_id"
    t.integer  "bank_account_id"
    t.index ["bank_account_id"], name: "index_bills_receives_on_bank_account_id", using: :btree
    t.index ["bills_pay_id"], name: "index_bills_receives_on_bills_pay_id", using: :btree
    t.index ["category_id"], name: "index_bills_receives_on_category_id", using: :btree
    t.index ["financial_account_id"], name: "index_bills_receives_on_financial_account_id", using: :btree
    t.index ["payment_form_id"], name: "index_bills_receives_on_payment_form_id", using: :btree
    t.index ["people_associated_id"], name: "index_bills_receives_on_people_associated_id", using: :btree
  end

  create_table "categories", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string   "name"
    t.string   "reduced_code"
    t.integer  "parent_id"
    t.integer  "type_subcategory", default: 1
    t.boolean  "status",           default: true
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  create_table "category_hierarchies", id: false, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.integer "ancestor_id",   null: false
    t.integer "descendant_id", null: false
    t.integer "generations",   null: false
    t.index ["ancestor_id", "descendant_id", "generations"], name: "category_anc_desc_idx", unique: true, using: :btree
    t.index ["descendant_id"], name: "category_desc_idx", using: :btree
  end

  create_table "companies", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string   "name"
    t.string   "email"
    t.string   "address"
    t.integer  "number"
    t.string   "complement"
    t.string   "zipcode"
    t.string   "burgh"
    t.string   "city"
    t.string   "state"
    t.string   "phone"
    t.text     "benefit",      limit: 65535
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.integer  "segment_id"
    t.date     "agreement_at"
    t.string   "cell_phone"
    t.index ["segment_id"], name: "index_companies_on_segment_id", using: :btree
  end

  create_table "customer_configurations", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string   "name"
    t.string   "address"
    t.string   "city"
    t.string   "state"
    t.string   "cnpj"
    t.string   "street"
    t.string   "phone"
    t.string   "cell_phone"
    t.date     "date_fundation"
    t.string   "logo"
    t.string   "president"
    t.text     "ficha",                   limit: 65535
    t.string   "menu_people_associateds",                                        default: "Filiados"
    t.boolean  "status",                                                         default: true
    t.datetime "created_at",                                                                          null: false
    t.datetime "updated_at",                                                                          null: false
    t.decimal  "total_maximum_salary",                  precision: 10, scale: 2, default: "0.0"
    t.integer  "discount_percentage",                                            default: 0
    t.integer  "idade_limite_estudante",                                         default: 24
    t.string   "signature"
  end

  create_table "departments", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string   "name"
    t.text     "description", limit: 65535
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "dependents", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.integer  "people_associated_id"
    t.string   "name"
    t.date     "birthdate"
    t.integer  "degree_of_kinship"
    t.datetime "created_at",                                           null: false
    t.datetime "updated_at",                                           null: false
    t.boolean  "with_special_needs",                   default: false
    t.text     "validate_statement",     limit: 65535
    t.boolean  "active",                               default: true
    t.string   "other_manual"
    t.date     "benefit_until"
    t.string   "username",                             default: "",    null: false
    t.string   "phone"
    t.string   "cell_phone"
    t.string   "encrypted_password",                   default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                        default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "cpf"
    t.string   "rg"
    t.string   "dispatcher_organ"
    t.string   "is_student"
    t.string   "institution_name"
    t.index ["people_associated_id"], name: "index_dependents_on_people_associated_id", using: :btree
  end

  create_table "efforts", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string   "name"
    t.boolean  "to_describe"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "financial_accounts", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string   "name"
    t.boolean  "status",     default: true
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "heritage_groups", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "inventories", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string   "description"
    t.string   "unit"
    t.integer  "minimum_balance"
    t.integer  "opening_balance"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "inventory_movements", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.integer  "inventory_id"
    t.integer  "type_balance"
    t.integer  "balance"
    t.decimal  "amount",       precision: 10
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.index ["inventory_id"], name: "index_inventory_movements_on_inventory_id", using: :btree
  end

  create_table "monthly_payments", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.integer  "people_associated_id"
    t.decimal  "amount",                             precision: 10, scale: 2, default: "0.0"
    t.decimal  "amount_paid",                        precision: 10, scale: 2, default: "0.0"
    t.date     "due_date"
    t.date     "pay_day"
    t.boolean  "paid",                                                        default: false
    t.text     "observation",          limit: 65535
    t.integer  "portion"
    t.datetime "created_at",                                                                  null: false
    t.datetime "updated_at",                                                                  null: false
    t.index ["people_associated_id"], name: "index_monthly_payments_on_people_associated_id", using: :btree
  end

  create_table "occupations", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "offices", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "patrimonies", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string   "name"
    t.text     "description",                 limit: 65535
    t.integer  "quantity"
    t.date     "date_of_acquisition"
    t.decimal  "amount",                                    precision: 10
    t.integer  "patrimony_number"
    t.boolean  "active",                                                             default: true
    t.datetime "created_at",                                                                         null: false
    t.datetime "updated_at",                                                                         null: false
    t.boolean  "car"
    t.string   "type_car"
    t.string   "year_car"
    t.decimal  "current_amount",                            precision: 10, scale: 2, default: "0.0"
    t.date     "date_of_incorporation"
    t.string   "request_of"
    t.string   "entry_note"
    t.string   "type_incorporation_describe"
    t.string   "effort_describe"
    t.string   "inactive_describe"
    t.integer  "supplier_id"
    t.integer  "room_id"
    t.integer  "heritage_group_id"
    t.integer  "type_incorporation_id"
    t.integer  "effort_id"
    t.index ["effort_id"], name: "index_patrimonies_on_effort_id", using: :btree
    t.index ["heritage_group_id"], name: "index_patrimonies_on_heritage_group_id", using: :btree
    t.index ["room_id"], name: "index_patrimonies_on_room_id", using: :btree
    t.index ["supplier_id"], name: "index_patrimonies_on_supplier_id", using: :btree
    t.index ["type_incorporation_id"], name: "index_patrimonies_on_type_incorporation_id", using: :btree
  end

  create_table "payment_forms", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string   "name"
    t.boolean  "status",     default: true
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "people_associateds", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.integer  "number_registration"
    t.string   "name"
    t.date     "birthdate"
    t.string   "gender"
    t.string   "email"
    t.string   "phone"
    t.string   "address"
    t.integer  "number"
    t.string   "complement"
    t.string   "zipcode"
    t.string   "burgh"
    t.string   "city"
    t.string   "state"
    t.string   "cpf"
    t.string   "rg"
    t.string   "marital_status"
    t.string   "place_birth"
    t.integer  "scholarity"
    t.string   "profession"
    t.string   "photo"
    t.integer  "situation"
    t.string   "mother"
    t.string   "father"
    t.string   "breed"
    t.string   "title_voter"
    t.string   "zone_voter"
    t.string   "section_voter"
    t.date     "admission_date"
    t.integer  "bond"
    t.datetime "created_at",                                                                                  null: false
    t.datetime "updated_at",                                                                                  null: false
    t.datetime "validity_card"
    t.boolean  "partner",                                                                     default: false
    t.string   "dispatcher_organ"
    t.boolean  "father_mother",                                                               default: false
    t.date     "start_registration"
    t.integer  "office_id"
    t.integer  "occupation_id"
    t.integer  "department_id"
    t.string   "spouse"
    t.text     "observation",                          limit: 65535
    t.string   "cell_phone1"
    t.string   "cell_phone2"
    t.string   "hollering_registration"
    t.date     "affiliate_date"
    t.integer  "workplace_id"
    t.date     "parading_date"
    t.string   "username",                                                                    default: "",    null: false
    t.string   "encrypted_password",                                                          default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                                                               default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.integer  "discount_percentage",                                                         default: 0
    t.decimal  "fixed_value",                                        precision: 10, scale: 2, default: "0.0"
    t.decimal  "gross_salary",                                       precision: 10, scale: 2, default: "0.0"
    t.boolean  "in_analysis",                                                                 default: false
    t.integer  "blood_type",                                                                  default: 0
    t.boolean  "is_allergic",                                                                 default: false
    t.boolean  "take_controlled_medicine",                                                    default: false
    t.text     "take_controlled_medicine_description", limit: 65535
    t.boolean  "term_of_consent",                                                             default: false
    t.string   "token"
    t.index ["cpf"], name: "index_people_associateds_on_cpf", unique: true, using: :btree
    t.index ["department_id"], name: "index_people_associateds_on_department_id", using: :btree
    t.index ["reset_password_token"], name: "index_people_associateds_on_reset_password_token", unique: true, using: :btree
  end

  create_table "professionals", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string   "name"
    t.string   "cpf"
    t.string   "rg"
    t.string   "advice"
    t.integer  "type_function"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.boolean  "active",        default: true
  end

  create_table "role_users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.integer  "role_id"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["role_id"], name: "index_role_users_on_role_id", using: :btree
    t.index ["user_id"], name: "index_role_users_on_user_id", using: :btree
  end

  create_table "roles", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string   "name"
    t.text     "permissions", limit: 65535
    t.integer  "position"
    t.boolean  "assignable"
    t.integer  "builtin"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "rooms", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "segments", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "settings", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string   "var",                       null: false
    t.text     "value",       limit: 65535
    t.string   "target_type",               null: false
    t.integer  "target_id",                 null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["target_type", "target_id", "var"], name: "index_settings_on_target_type_and_target_id_and_var", unique: true, using: :btree
    t.index ["target_type", "target_id"], name: "index_settings_on_target_type_and_target_id", using: :btree
  end

  create_table "subcategories", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.integer  "category_id"
    t.string   "name"
    t.string   "reduced_code"
    t.boolean  "status",       default: true
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.index ["category_id"], name: "index_subcategories_on_category_id", using: :btree
  end

  create_table "suppliers", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string   "name"
    t.string   "phone"
    t.string   "email"
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
    t.string   "cpf"
    t.string   "cnpj"
    t.string   "razao_social"
    t.string   "rg"
    t.string   "emitter"
    t.string   "uf"
    t.string   "cell_phone"
    t.text     "obs",          limit: 65535
    t.integer  "entity_type",                default: 2
    t.string   "address"
    t.integer  "number"
    t.string   "complement"
    t.string   "zipcode"
    t.string   "burgh"
    t.string   "city"
    t.string   "state"
    t.boolean  "status",                     default: true
  end

  create_table "system_attachments", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.integer  "dependent_id"
    t.integer  "bills_pay_id"
    t.integer  "bills_receife_id"
    t.string   "name"
    t.string   "archive"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.integer  "people_associated_id"
  end

  create_table "type_incorporations", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string   "name"
    t.boolean  "to_describe"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string   "name",                   default: "",   null: false
    t.string   "username",               default: "",   null: false
    t.string   "email",                  default: "",   null: false
    t.string   "encrypted_password",     default: "",   null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,    null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.integer  "professional_id"
    t.boolean  "active",                 default: true
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  create_table "workplaces", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "appointbook_peopleassocis", "appointment_books"
  add_foreign_key "appointbook_peopleassocis", "people_associateds"
  add_foreign_key "appointment_books", "professionals"
  add_foreign_key "bills_pays", "categories"
  add_foreign_key "bills_pays", "payment_forms"
  add_foreign_key "bills_pays", "people_associateds"
  add_foreign_key "bills_pays", "suppliers"
  add_foreign_key "bills_receives", "categories"
  add_foreign_key "bills_receives", "financial_accounts"
  add_foreign_key "bills_receives", "payment_forms"
  add_foreign_key "bills_receives", "people_associateds"
  add_foreign_key "dependents", "people_associateds"
  add_foreign_key "inventory_movements", "inventories"
  add_foreign_key "monthly_payments", "people_associateds"
  add_foreign_key "patrimonies", "efforts"
  add_foreign_key "patrimonies", "heritage_groups"
  add_foreign_key "patrimonies", "rooms"
  add_foreign_key "patrimonies", "suppliers"
  add_foreign_key "patrimonies", "type_incorporations"
  add_foreign_key "role_users", "roles"
  add_foreign_key "role_users", "users"
  add_foreign_key "subcategories", "categories"
end
