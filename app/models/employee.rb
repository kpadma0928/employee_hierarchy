class Employee < ActiveRecord::Base
  has_many :reportees, class_name: 'Employee', foreign_key: :reporter_id
  belongs_to :reporter, class_name: 'Employee', optional: true, foreign_key: :reporter_id 

  validates_presence_of :designation
  validate :reporter_validation

  before_save :generate_emp_code

  scope :active, -> { where(active: true) }


  def self.hierarchy(designation)
    output = []
    Employee.where(designation: designation).each do |emp|
      output << data(emp)
    end
    output.to_json
  end

  def self.data(employee)
    employees = []
    active_reportees = employee.reportees.active
    unless active_reportees.blank?
      active_reportees.each do |emp|
        employees << data(emp)
      end
    end
    {id: employee.id, name: employee.name, code: employee.emp_code, reportees: employees}
  end

  def make_employee_inactive
    self.reportees.update_all(reporter_id: self.reporter_id)
    self.update_attributes(active: false)
  end

  def self.top_10_employees
    Employee.order("salary DESC").limit(10)
  end

  private

  def generate_emp_code
    self.emp_code = "ACC00#{Employee.count + 1}" if emp_code.blank?

  end

  def not_ceo_or_sde
    not ['CEO', 'SDE'].include?(designation)
  end

  def reporter_validation
    if reporter_id.blank? &&  !(['CEO', 'SDE'].include?(designation))
      self.errors[:base] << "Select Reporter to whom you have to report"
    elsif designation == 'VP' && Employee.find(reporter_id).designation != 'CEO'
      self.errors[:base] << "Please select CEO as reporter"
    elsif designation == 'Director' &&  !(['CEO', 'VP'].include?(Employee.find(reporter_id).designation))
      self.errors[:base] << "Please select CEO/VP as reporters"
    elsif designation == 'Manager' && !(['CEO', 'VP', 'Director'].include?(Employee.find(reporter_id).designation))
      self.errors[:base] << "Please select CEO/VP/Director as reporters"
    elsif designation == 'SDE' &&  !(['CEO', 'VP', 'Director', 'Manager'].include?(Employee.find(reporter_id).designation))
      self.errors[:base] << "Please select CEO/VP/Director/Manager as reporters"
    end
  end
end
