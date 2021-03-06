# encoding: UTF-8
require_relative "./high_sn_hn/setup"
require_relative "./high_sn_hn/parsers/hn_response"
require_relative "./high_sn_hn/parsers/hn_high_id"
require_relative "./high_sn_hn/parsers/hn_item"
require_relative "./high_sn_hn/parsers/hn_top_stories"
require_relative "./high_sn_hn/models/comment"
require_relative "./high_sn_hn/models/posting"
require_relative "./high_sn_hn/models/snapshot"
require_relative "./high_sn_hn/models/story"
require_relative "./high_sn_hn/models/title"
require_relative "./high_sn_hn/services/generate_shortlink"
require_relative "./high_sn_hn/services/high_id_watcher"
require_relative "./high_sn_hn/services/process_submissions"
require_relative "./high_sn_hn/services/re_enqueue_item"
require_relative "./high_sn_hn/services/tweet_submission"
require_relative "./high_sn_hn/workers/high_id_worker"
require_relative "./high_sn_hn/workers/items_worker"
require_relative "./high_sn_hn/workers/top_story_worker"

require 'logger'
PWD = File.dirname(File.expand_path(__FILE__))
LOGGER = Logger.new("#{PWD}/../log/high_sn_hn.log")

require 'redis'
require 'resque'
REDIS = Redis.new

module HighSnHn

  class Keys
    def self.twitter
      keys = YAML.load_file(File.join(__dir__, '../config/app_secret.yml'))
      keys["twitter"]
    end

    def self.google
      keys = YAML.load_file(File.join(__dir__, '../config/app_secret.yml'))
      keys["google"]
    end
  end

end