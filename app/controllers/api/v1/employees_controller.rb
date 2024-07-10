class Api::V1::EmployeesController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    employees = Employee.all
    render json: employees, status: 200
  end

  def show
    employee = Employee.find_by(id: params[:id])
    yearly_salary = employee.salary*12
    tax = get_tax_ammount(yearly_salary)
    cess = get_cess_ammount(yearly_salary)
    employee_tax_details = {
       "employee_id":employee.id,
       "firstname":employee.firstname,
       "lastname":employee.lastname,
       "yearly salary":(employee.salary*12),
       "cess":cess,
       "tax": tax
      }

    if employee
      render json: employee_tax_details, status: 200
    else
      render json: {
        error: "employee with given id not found"
      }
    end 
  end

  def create
    employee = Employee.new(
      firstname: employee_params[:firstname],
      lastname:employee_params[:lastname],
      email:employee_params[:email],
      phonenumber: employee_params[:phonenumber],
      doj:employee_params[:doj],
      salary:employee_params[:salary]
    )
    if employee.save
      render json: employee, status: 200
    else
      render json: {
        error: "error in creating employee"
      }
    end 
  end

  def get_cess_ammount(yearly_salary)
    if yearly_salary > 2500000 
      cess = (yearly_salary-2500000)*3/100
    else
      cess = 0
    end
    cess
  end

  def get_tax_ammount(yearly_salary)
    if yearly_salary <= 250000
      tax = 0
    elsif yearly_salary > 250000 && yearly_salary <= 500000
      tax = yearly_salary*5/100
    elsif yearly_salary > 500000 && yearly_salary <= 1000000
      tax = yearly_salary*10/100
    else
      tax = yearly_salary*20/100
    end
    tax
  end

  private
  def employee_params
    params.require(:employee).permit(
      :firstname,
      :lastname,
      :email,
      :phonenumber,
      :doj,
      :salary
    )
  end
end
