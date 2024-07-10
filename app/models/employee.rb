class Employee < ApplicationRecord
    validates_presence_of :firstname, :lastname, :email, :phonenumber, :doj, :salary
end
