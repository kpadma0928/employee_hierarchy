class EmployeesController < ApplicationController
  # protect_from_forgery with: :exception
 skip_before_action :verify_authenticity_token  

  def create_employee_details
    designation = params[:designation]
    if params[:emp_code].present?
      emp = Employee.find_by_emp_code(params[:emp_code]) || Employee.new(employee_params)
      emp.attributes = employee_params
    else
      emp = Employee.new(employee_params)
    end  
    if emp.save
      render json: {success: "Employee Created Successfully", employee: emp.to_json}
    else
      render json: emp.errors.messages.to_json
    end

  end

  def hierarchy
    if params[:designation].blank?
      render json: {error: 'Please select designation'}
    else
      render json: Employee.hierarchy(params[:designation])
    end
  end

  def delete_employee
    if params[:emp_code].blank?
      render json: {error: 'Please enter employee code'}
    else
      emp = Employee.find_by_emp_code(params[:emp_code])
      if emp.present?
        render json: {employee: emp.to_json, archived: emp.make_employee_inactive}
      else
        render json: {message: "Employee not found"}
      end
    end
  end

  def top_10_employees
    render json: Employee.top_10_employees.to_json
  end

  private

  def employee_params
    params.permit(:name, :salary, :rating, :reporter_id, :designation, :active)
  end
end
