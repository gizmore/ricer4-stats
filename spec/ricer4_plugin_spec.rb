require 'spec_helper'

describe Ricer4::Plugins::Stats do
  
  # LOAD
  bot = Ricer4::Bot.new("ricer4.spec.conf.yml")
  bot.db_connect
  ActiveRecord::Magic::Update.install
  ActiveRecord::Magic::Update.run
  bot.load_plugins
  ActiveRecord::Magic::Update.run

  it("has a working stats command") do
    expect(bot.exec_line_for('Stats/Stats')).to start_with("msg_stats:{\"active_servers\":")
  end
  
end
