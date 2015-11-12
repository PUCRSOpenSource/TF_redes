
require_relative 'modules/ip'
require_relative 'classes/node'
require_relative 'classes/router'
require_relative 'classes/router_port'
require_relative 'classes/router_table'
require_relative 'classes/router_table_entry'
require_relative 'network_manager'

include Ip

rt = RouterTable.new
graph_nodes = Array.new
counter = 0

File.open ARGV[0], "r" do |f|
	f.each_line do |line|
		if line[0] == "#"
			counter += 1
			next
		end
		line = line.split ','
		case counter
		when 1 #when reading node
			node = Node.new
			node.name    = line[0]
			node.mac     = line[1]
			ip           = line[2].split '/'
			node.ip      =   ip[0].strip
			node.prefix  =   ip[1].to_i
			node.gateway = line[3].strip
			graph_nodes << node
		when 2 #when reading router
			router       = Router.new
			router_ports = Array.new
			router.name  = line[0]
			port_counter = 2
			line[1].to_i.times do |x|
				router_port         = RouterPort.new
				router_port.mac     = line[port_counter]
				ip                  = line[port_counter + 1].split('/')
				router_port.ip      =   ip[0].strip
				router_port.prefix  =   ip[1].to_i
				router_ports       << router_port
				port_counter       += 2
			end
			router.ports = router_ports
			graph_nodes << router
		when 3 #when reading routertable
			rte          = RouterTableEntry.new
			rte.name     = line[0]
			ip           = line[1].split '/'
			rte.net_dest =   ip[0].strip
			rte.prefix   =   ip[1].to_i
			rte.next_hop = line[2]
			rte.port     = line[3]
			rt.entry_list << rte
		end
	end
	manager = NetworkManager.new
	manager.graph_nodes = graph_nodes
	manager.router_table = rt
	manager.generate_graph
	manager.setup_router_table

	if ARGV[1] == 'ping'
		manager.ping ARGV[2], ARGV[3]
	elsif ARGV[1] == 'traceroute'
		manager.traceroute ARGV[2], ARGV[3]
	end
end

