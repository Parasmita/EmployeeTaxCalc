class Api::V1::EmployeesController < ApplicationController
  skip_before_action :verify_authenticity_token


  def index
    employees = Employee.all
    render json: employees, status: 200
  end

  def show
    employee = Employee.find_by(id: params[:id])
    yearly_salary = get_yearly_salary(employee.salary,employee.doj)
    tax = get_tax_ammount(yearly_salary)
    cess = get_cess_ammount(yearly_salary)

    employee_tax_details = {
       "Employee Code":employee.id,
       "FirstName":employee.firstname,
       "LastName":employee.lastname,
       "Yearly Salary":'%.2f' % yearly_salary,
       "Cess amount":'%.2f' % cess,
       "Tax amount": '%.2f' % tax
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

  def get_yearly_salary(monthly_salary,doj)
    yearly_salary = doj < Date.new(Date.today.prev_year.year,4,1) ? monthly_salary*12 : (monthly_salary*12/365)*(Date.new(Date.today.year,4,1) - doj).to_i
  end

  def get_cess_ammount(yearly_salary)
    cess = yearly_salary > 2500000 ? cess = (yearly_salary-2500000)*3/100 : 0
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
