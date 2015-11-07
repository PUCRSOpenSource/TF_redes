class NetworkManager

	attr_accessor :graph_nodes
	attr_accessor :router_table

	# Graph related functions

	def generate_graph
		graph_nodes.each do |node1|
			graph_nodes.each do |node2|
				if node1 != node2
					connected = check_if_connected node1, node2
					if connected
						create_connection node1, node2
					end
				end
			end
		end
	end

	def get_networks graph_node
		networks = Array.new
		if graph_node.is_a? Node
			net = addr_to_network graph_node.ip, graph_node.prefix
			networks << net
		else
			graph_node.ports.each do |port|
				net = addr_to_network port.ip, port.prefix
				networks << net
			end
		end
		return networks
	end

	def check_if_connected node1, node2
		networks1 = get_networks node1
		networks2 = get_networks node2
		networks1.each do |net1|
			networks2.each do |net2|
				if net1 == net2
					return true
				end
			end
		end
		return false
	end

	def create_connection node1, node2
		node1.neighbors << node2
	end

	def setup_router_table
		router_list = graph_nodes.select {|r| r.is_a? Router}
		router_list.each do |r|
			r.router_table = router_table
		end
	end

	# Commands

	def ping ip1, ip2
		start_node = find_node ip1
		start_node.send_message ip2, 8
	end

	def find_node ip
		graph_nodes.each do |node|
			if node.is_a? Node
				if node.ip == ip
					return node
				end
			end
		end
		return nil
	end

















end