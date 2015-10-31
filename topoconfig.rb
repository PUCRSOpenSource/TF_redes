
require_relative 'ip'
require_relative 'node'
require_relative 'router'
require_relative 'router_port'
require_relative 'router_table'
require_relative 'router_table_entry'

include Ip

ip_dictionary = Hash.new

def create_dummy_stuff
	node = Node.new
	node.name = "node1"
	node.mac = 1
	node.ip = "192.168.10.2"
	node.prefix = 24
	node.gateway = "192.168.0.1"

	router = Router.new
	router.name = "router1"

	port = RouterPort.new
	port.number = 1
	port.mac = 2
	port.ip = "192.168.0.1"
	port.prefix = 24

	router.ports = Array.new
	router.ports << port

	ip_dictionary = {node.ip => node, port.ip => router}
end


# ip_dictionary = initialize a dictionary with all the existing ips being the keys and the objects related to it being the values

puts dec_to_addr addr_to_dec '192.168.0.1'

counter = 0
File.open ARGV.first, "r" do |f|
	rt = RouterTable.new
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
			node.ip      =   ip[0]
			node.prefix  =   ip[1].to_i
			node.gateway = line[3]
			puts node.to_s
		when 2 #when reading router
			router       = Router.new
			router_ports = Array.new
			router.name  = line[0]
			port_counter = 2
			line[1].to_i.times do |x|
				router_port         = RouterPort.new
				router_port.mac     = line[port_counter]
				ip                  = line[port_counter + 1].split '/'
				router_port.ip      =   ip[0]
				router_port.prefix  =   ip[1].to_i
				router_ports       << router_port
				port_counter       += 2
			end
			router.ports = router_ports
			puts router.to_s
		when 3 #when reading routertable
			rte          = RouterTableEntry.new
			rte.name     = line[0]
			ip           = line[1].split '/'
			rte.net_dest =   ip[0]
			rte.prefix   =   ip[1]
			rte.next_hop = line[2]
			rte.port     = line[3]
			rt.entry_list << rte
		end
	end
	puts rt.to_s
end

#create_dummy_stuff
