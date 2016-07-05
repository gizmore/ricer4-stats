module Ricer4::Plugins::Stats
  class Plugstats < Ricer4::Plugin
    
    trigger_is :plugstats
    
    def plugin_init
      # Count when something is triggered    
      arm_subscribe('ricer/triggered') do |sender, plugin, user|
        TriggerCounter.count(plugin.id, user.id)
      end
    end
    
    ################
    ### Handlers ###
    ################
    has_usage  '', function: :execute_show_total
    has_usage  '<plugin>', function: :execute_show_sum
    has_usage  '<plugin> <page>', function: :execute_show_topten
    has_usage  '<plugin> <user>', function: :execute_show_user
    
    def execute_show_total
      rply :all_plugins, plugins:bot.loader.plugins.length, total:TriggerCounter.all.summed.first.sum
    end
    
    def execute_show_sum(plugin)
      rply :one_plugin, plugin:plugin.plugin_trigger, count:TriggerCounter.for_plugin(plugin).summed.first.sum
    end
    
    def execute_show_topten(plugin, page)
      out = []
      counters = TriggerCounter.for_plugin(plugin).order('calls DESC').page(page).per(10)
      rank = counters.offset_value
      counters.each do |counter|
        rank += 1
        out.push("#{rank}.#{counter.user.display_name}(x#{counter.calls})")
      end
      return rplyr :err_page if out.length == 0
      rply :toptenpage, plugin:plugin.plugin_trigger, page:counters.current_page, pages:counters.total_pages, out:out.join(', ')
    end
    
    def execute_show_user(plugin, user)
      rply :one_plugin_and_user, plugin:plugin.plugin_trigger, user:user.display_name, count:TriggerCounter.for_plugin(plugin).for_user(user).first.calls
    end
    
  end
end
