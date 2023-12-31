# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever



# root_path認識に必要
require File.expand_path(File.dirname(__FILE__) + "/environment")
# cronを実行する環境変数
rails_env = Rails.env.to_sym
# 環境変数の設定
set :environment, rails_env
# ログの出力先の設定
set :output, "log/cron.log"


# 処理時間の指定(2分)、1週間の場合→every 1.week
every 2.minute do
  runner "Batch::RemoveUnuseTag.remove_unuse_tag"
rescue => e
  Rails.logger.error("aborted rails runner")
  raise e
end
