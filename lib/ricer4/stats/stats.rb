module Ricer4::Plugins::Stats
  class Stats < Ricer4::Plugin

    trigger_is :stats

    has_setting name: :uptime, scope: :bot, type: :duration, permission: :responsible, default: 0
    
    def plugin_init
      arm_subscribe('ricer/stopped') do
        increase_setting(:uptime, bot.uptime)
        bot.log.debug("Stats/Stats increases total_uptime by #{bot.uptime.to_f} which is now: #{show_setting(:uptime)}")
      end
    end
    
    def total_uptime
      get_setting(:uptime) + bot.uptime
    end

    has_usage
    def execute
      rply(:msg_stats,
        active_servers: Ricer4::Server.online.count,
        total_servers: Ricer4::Server.count,
        channels: Ricer4::Channel.online.count,
        users: Ricer4::User.online.count,
        plugins: bot.loader.plugins.count,
        events: ActiveRecord::Magic::Event::Container.total_events,
        listeners: ActiveRecord::Magic::Event::Subscriptions.total_hooks,
        uptime: human_duration(bot.uptime),
        runtime: human_duration(total_uptime),
      )
    end

  end
end
