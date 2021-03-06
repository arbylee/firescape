require 'pry'
require 'pry-remote'
require 'redis'

require 'java'

require './lib/hex-string.jar'
require './lib/jmf.jar'
require './lib/junit.jar'
require './lib/mina.jar'
require './lib/slf4j.jar'
require './lib/xpp3.jar'
require './lib/xstream.jar'
require './lib/jedis.jar'
require './lib/gson.jar'
require './lib/commons-pool2.jar'

require './rscd.jar'

server = Java::OrgRscdaemonServer::Server.new

class FireScape
  
  @@world = Java::OrgRscdaemonServerModel::World.get_world

  def enum_players
    @@world.players
  end

  def find_player(id)
    @@world.players.get(id)
  end

  def give_item(player_id, item_id, quantity = 1)
    item = Java::OrgRscdaemonServerModel::InvItem.new(item_id, quantity)
    player = find_player(player_id)
    player.get_inventory.add(item)
    player.get_action_sender.send_inventory
  end
end

slack = Thread.new do  
  redis = Redis.new

  redis.subscribe('game_chat') do |on|
    on.message do |channel, msg|
      # Do something with the channel messages here
    end
  end
end

mgmt = Thread.new do
  @@is_running = true

  game = FireScape.new

  def kill_serv
    @@is_running = false
    exit
  end

  while(@@is_running)
    binding.remote_pry('localhost', '9040')
  end
end

slack.join
mgmt.join

abort
