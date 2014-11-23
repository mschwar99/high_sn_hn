module HighSnHn

  class ItemsWorker
    @queue = :items_queue

    def self.perform(min_item, max_item)
      return unless min_item.to_i > 0 && max_item.to_i > 0
      (min_item..max_item).each do |id|
        LOGGER.info("Fetching HnItem ##{id}")
        begin
          klass = false
          item = HighSnHn::HnItem.new(id)

          if item.complete?
            LOGGER.info("this came back complete #{item.data}")
            return true
          else
            item.fetch
          end


          if item.data['type'] == 'story'
            klass = HighSnHn::Story
          elsif item.data['type'] == 'comment'
            klass = HighSnHn::Comment
          end

          if klass
            model = klass.where(hn_id: id).first_or_create
            model.update(item.data)
          end
        rescue NullItemResult => e
          # there was no HTTP result - requeue
          LOGGER.error("#{e}")
          Resque.enqueue(HighSnHn::ItemsWorker, id, id)
        end
      end
    rescue Exception => e
      LOGGER.error("there was some other error: #{e}")
      LOGGER.error("#{e.backtrace.join("\n")}")
    end
  end
end