# -*- encoding : utf-8 -*-
class Role < ApplicationRecord
  # Custom coder for the permissions attribute that should be an
  # array of symbols. Rails 3 uses Psych which can be *unbelievably*
  # slow on some platforms (eg. mingw32).
  class PermissionsAttributeCoder
    def self.load(str)
      str.to_s.scan(/:([a-z0-9_]+)/).flatten.map(&:to_sym)
    end

    def self.dump(value)
      YAML.dump(value)
    end
  end

  # Built-in roles
  BUILTIN_NON_MEMBER = 1
  BUILTIN_ANONYMOUS  = 2

  ISSUES_VISIBILITY_OPTIONS = [
    ['all', :label_issues_visibility_all],
    ['default', :label_issues_visibility_public],
    ['own', :label_issues_visibility_own]
  ]

  scope :sorted, lambda { order("#{table_name}.builtin ASC, #{table_name}.position ASC") }
  scope :givable, lambda { order("#{table_name}.position ASC").where(:builtin => 0) }
  scope :builtin, lambda { |*args|
    compare = (args.first == true ? 'not' : '')
    where("#{compare} builtin = 0")
  }

  before_destroy :check_deletable

  has_many :role_users, :dependent => :destroy
  has_many :users, :through => :role_users


  serialize :permissions, ::Role::PermissionsAttributeCoder


  validates_presence_of :name
  validates_uniqueness_of :name
  validates_length_of :name, :maximum => 30
  validates_inclusion_of :issues_visibility,
    :in => ISSUES_VISIBILITY_OPTIONS.collect(&:first),
    :if => lambda {|role| role.respond_to?(:issues_visibility)}

  # Copies attributes from another role, arg can be an id or a Role
  def copy_from(arg, options={})
    return unless arg.present?
    role = arg.is_a?(Role) ? arg : Role.find_by_id(arg.to_s)
    self.attributes = role.attributes.dup.except("id", "name", "position", "builtin", "permissions")
    self.permissions = role.permissions.dup
    self
  end

  def permissions=(perms)
    perms = perms.collect {|p| p.to_sym unless p.blank? }.compact.uniq if perms
    write_attribute(:permissions, perms)
  end

  def add_permission!(*perms)
    self.permissions = [] unless permissions.is_a?(Array)

    permissions_will_change!
    perms.each do |p|
      p = p.to_sym
      permissions << p unless permissions.include?(p)
    end
    save!
  end

  def remove_permission!(*perms)
    return unless permissions.is_a?(Array)
    permissions_will_change!
    perms.each { |p| permissions.delete(p.to_sym) }
    save!
  end

  # Returns true if the role has the given permission
  def has_permission?(perm)
    !permissions.nil? && permissions.include?(perm.to_sym)
  end

  def <=>(role)
    if role
      if builtin == role.builtin
        position <=> role.position
      else
        builtin <=> role.builtin
      end
    else
      -1
    end
  end

  def to_s
    name
  end

  def name
    case builtin
    when 1; "Não Membro"
    when 2; "Anônimo"
    else; read_attribute(:name)
    end
  end

  # Return true if the role is a builtin role
  def builtin?
    self.builtin != 0
  end

  # Return true if the role is the anonymous role
  def anonymous?
    builtin == 2
  end

  # Return true if the role is a project member role
  def member?
    !self.builtin?
  end

  # Return true if role is allowed to do the specified action
  # action can be:
  # * a parameter-like Hash (eg. :controller => 'projects', :action => 'edit')
  # * a permission Symbol (eg. :edit_project)
  def allowed_to?(action)
    if action.is_a? Hash
      allowed_actions.include? "#{action[:controller]}/#{action[:action]}"
    else
      allowed_permissions.include? action
    end
  end

  # Return all the permissions that can be given to the role
  def setable_permissions
    setable_permissions = Cms::AccessControl.permissions - Cms::AccessControl.public_permissions
    setable_permissions -= Cms::AccessControl.members_only_permissions if self.builtin == BUILTIN_NON_MEMBER
    setable_permissions -= Cms::AccessControl.loggedin_only_permissions if self.builtin == BUILTIN_ANONYMOUS
    setable_permissions
  end

  # Find all the roles that can be given to a project member
  def self.find_all_givable
    Role.givable.all
  end

  # Return the builtin 'non member' role.  If the role doesn't exist,
  # it will be created on the fly.
  def self.non_member
    find_or_create_system_role(BUILTIN_NON_MEMBER, 'Non member')
  end

  # Return the builtin 'anonymous' role.  If the role doesn't exist,
  # it will be created on the fly.
  def self.anonymous
    find_or_create_system_role(BUILTIN_ANONYMOUS, 'Anonymous')
  end

private

  def allowed_permissions
    @allowed_permissions ||= permissions + Cms::AccessControl.public_permissions.collect {|p| p.name}
  end

  def allowed_actions
    @actions_allowed ||= allowed_permissions.inject([]) { |actions, permission| actions += Cms::AccessControl.allowed_actions(permission) }.flatten
  end

  def check_deletable
    raise "Can't delete role" if users.any?
  end

  def self.find_or_create_system_role(builtin, name)
    role = where(:builtin => builtin).first
    if role.nil?
      role = create(:name => name, :position => 0) do |r|
        r.builtin = builtin
      end
      raise "Unable to create the #{name} role." if role.new_record?
    end
    role
  end
end

