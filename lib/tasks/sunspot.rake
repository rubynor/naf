module DMSunspot
  module Fixes

    def solr_index(opts={})
      options = {
        :batch_size => 50,
        :batch_commit => true,
        :include => self.sunspot_options[:include],
        :first_id => 0
      }.merge(opts)
      if options[:batch_size]
        counter = 0
        find_in_batches(:include => options[:include], :batch_size => options[:batch_size]) do |records|
          solr_benchmark options[:batch_size], counter do
            Sunspot.index(records)
          end
          Sunspot.commit if options[:batch_commit]
          counter += 1
        end
        Sunspot.commit unless options[:batch_commit]
      else
        Sunspot.index!(all)
      end
    end

  end
end
namespace :dmsunspot do

  desc "Reindex all solr models that are located in your application's models directory."
  # This task depends on the standard Rails file naming \
  # conventions, in that the file name matches the defined class name. \
  # By default the indexing system works in batches of 50 records, you can \
  # set your own value for this by using the batch_size argument. You can \
  # also optionally define a list of models to separated by a forward slash '/'
  #
  # $ rake sunspot:reindex                # reindex all models
  # $ rake sunspot:reindex[1000]          # reindex in batches of 1000
  # $ rake sunspot:reindex[false]         # reindex without batching
  # $ rake sunspot:reindex[,Post]         # reindex only the Post model
  # $ rake sunspot:reindex[1000,Post]     # reindex only the Post model in
  #                                       # batchs of 1000
  # $ rake sunspot:reindex[,Post+Author]  # reindex Post and Author model
  task :reindex, [:batch_size, :models] => :environment do |t, args|
    reindex_options = {:batch_commit => false}
    case args[:batch_size]
    when 'false'
      reindex_options[:batch_size] = nil
    when /^\d+$/
      reindex_options[:batch_size] = args[:batch_size].to_i if args[:batch_size].to_i > 0
    end
    unless args[:models]
      all_files = Dir.glob(Rails.root.join('app', 'models', '*.rb'))
      all_models = all_files.map { |path| File.basename(path, '.rb').camelize.constantize }
      #XXX hack to remove the dependency on activerecord.
      #when using sunspot w/ the patch, you need to explicitly include sunspot inside
      #each model you want to be searchable, hence rescue any NoMethodErrors for searchable?.
      sunspot_models = all_models.select { |m| m.searchable? rescue false }
    else
      sunspot_models = args[:models].split('+').map{|m| m.constantize}
    end
    sunspot_models.each do |model|
      model.extend DMSunspot::Fixes
      model.solr_reindex reindex_options
    end
  end

end