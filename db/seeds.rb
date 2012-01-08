# -*- encoding : utf-8 -*-
raise "populate locations first, then rerun seeds." if Location.count == 0

begin
u = User.create!(:email => 'nafadmin@rubynor.com',
:password => 'secret',
:password_confirmation => 'secret',
:super_admin => true,
:location => Location.first)
puts "User #{u} created"
rescue
  puts "nafadmin@rubynor.com already exits"
end

begin
u = User.create!(:email => 'naf@rubynor.com',
:password => 'secret',
:password_confirmation => 'secret',
:location => Location.first)

puts "User #{u} created"
rescue
  puts "naf@rubynor.com already exits"
end
