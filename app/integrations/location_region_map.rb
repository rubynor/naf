# -*- encoding : utf-8 -*-
class LocationRegionMap

  "1 = Nord, 2 = Sør, 3 = Øst, 4 = Vest, 5 = Oslofjord"
   def self.csv
     loc_reg = []
     File.open(Rails.root + "doc/naf-lokasjoner-regioner.csv") do |f|
       f.readlines.each do |line|
         entry = line.chomp.split(',')
         region = Region.where(name: (case entry[1]
         when "1" then 'Nord'
         when "2" then 'Sør'
         when "3" then 'Øst'
         when "4" then 'Vest'
         when "5" then 'Oslofjord'
         end)).first

         loc_reg << [entry[0], region]

       end
     end
     #puts loc_reg
     loc_reg
   end

   def self.add_region
     self.csv.each do |lm|
       l = Location.where(name: lm[0]).first
       if l
         puts "location #{l.name}"
         unless l.region
           l.update_attributes(region: lm[1])
           puts " updated to region #{l.region.name}"
         end
       else
         puts "NOT FOUND #{lm[0]}"
       end
     end
   end
end