#
# merges the latest ext.js admin app
#

task :merge_ext_app => :environment do

  #pull the latest into a folder
  system "git clone git@github.com:eserlan/naf.git #{Rails.root}/public/naf && mv #{Rails.root}/public/naf/src/main/webapp/app #{Rails.root}/public && rm -R #{Rails.root}/public/naf"
  #
  #system ""
end