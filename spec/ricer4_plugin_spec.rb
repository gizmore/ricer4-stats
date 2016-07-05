require 'spec_helper'

describe Ricer4::Plugins::Stats do
  
  # LOAD
  bot = Ricer4::Bot.new("ricer4.spec.conf.yml")
  bot.db_connect
  ActiveRecord::Magic::Update.install
  ActiveRecord::Magic::Update.run
  bot.load_plugins
  ActiveRecord::Magic::Update.run
  
  USERS = Ricer4::User
  STATS = Ricer4::Plugins::Stats::TriggerCounter
  
  it("Can flush stats") do
    USERS.destroy_all
    STATS.destroy_all
  end

  it("has a working stats command") do
    expect(bot.exec_line_as_for('Ugah', 'Test/Ping')).to start_with("msg_pong")
    expect(bot.exec_line_as_for('Ugah', 'Stats/Stats')).to start_with("msg_stats:{\"active_servers\":")
  end
  
  it("Does count a ping correctly") do
    expect(bot.exec_line_as_for("Ugah", "Stats/Plugstats")).to eq("all_plugins:{\"plugins\":70,\"total\":3}")
    expect(bot.exec_line_as_for("Ugah", "Stats/Plugstats", "Test/Ping")).to eq("one_plugin:{\"plugin\":\"ping\",\"count\":1}")
    expect(bot.exec_line_as_for('Ugah', 'Test/Ping')).to start_with("msg_pong")
    expect(bot.exec_line_as_for("Ugah", "Stats/Plugstats", "Test/Ping")).to eq("one_plugin:{\"plugin\":\"ping\",\"count\":2}")
    expect(bot.exec_line_as_for("Ugah", "Stats/Plugstats", "Test/Ping 1")).to eq("toptenpage:{\"plugin\":\"ping\",\"page\":1,\"pages\":1,\"out\":\"1.Ugаh:localhost(x2)\"}")
  end
  
end
