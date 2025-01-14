require './lib/registrant'

class Facility
  attr_reader :name, 
              :address, 
              :phone, 
              :services, 
              :collected_fees, 
              :registered_vehicles

  def initialize(name:, address:, phone:)
    @name = name
    @address = address
    @phone = phone
    @services = []
    @collected_fees = 0
    @registered_vehicles = []
  end

  def add_service(service)
    @services.push(service)
  end

  def register_vehicle(vehicle)
    if @services.include?('Vehicle Registration')
      @registered_vehicles.push(vehicle)
      vehicle.registration_today(Date.today)
      if vehicle.electric_vehicle? == true
        vehicle.plate_version(:ev)
        @collected_fees += 200
        
      elsif vehicle.antique? == true
        vehicle.plate_version(:antique)
        @collected_fees += 25
      else #regular
        vehicle.plate_version(:regular)
        @collected_fees += 100
      end
    else
      nil
    end
  end

  def administer_written_test(student)
    if @services.include?('Written Test') && student.age >= 16 && student.permit == true
      student.license_data[:written] = true
      true
    else
      false
    end
  end

  def administer_road_test(student)
    if @services.include?('Road Test') && student.license_data[:written] == true
      student.license_data[:license] = true
      true
    else
      false
    end
  end

  def renew_drivers_license(driver)
    if @services.include?('Renew License') && driver.license_data[:license] == true
      driver.license_data[:renewed] = true
      true
    else
      false
    end
  end

#The administer_x_tests/renew tests work differently from the register_vehicle method by one major factor
#The data type passing through administer_x_tests uses an attr_accessor to change the assigned value in the hash
#The register_vehicle method only uses an attr_reader, so a method within vehicle.rb had to be made to work around this function
end
