
class Router

	attr_accessor :name
	attr_accessor :ports
	attr_accessor :arp_table
	attr_accessor :neighbors
	attr_accessor :router_table

	def to_s
		"#{name},#{ports.size},#{ports.join ','}"
	end

	def initialize
		@arp_table = Hash.new
		@neighbors = Array.new
	end

	# Messages abstraction

	def send_message ip_origin, ip_dest, ttl
		# find next hop
		if has_network ip_dest
			port = find_port_by_net ip_dest
			next_ip = ip_dest
		else
			# find next hop some other way
			# port = ?
			# next_ip = ?
		end

		# check arp table
		if !arp_table.has_key?(next_ip)
			send_arp_request port, next_ip
		end
		send_icmp_request ip_origin, ip_dest, port.mac, arp_table[next_ip], ttl
	end

	def send_message_back ip_origin, ip_dest, ttl
		# find next hop
		if has_network ip_dest
			port = find_port_by_net ip_dest
			next_ip = ip_dest
		else
			# find next hop some other way
			# port = ?
			# next_ip = ?
		end

		# check arp table
		if !arp_table.has_key?(next_ip)
			send_arp_request port, next_ip
		end
		send_icmp_reply ip_origin, ip_dest, port.mac, arp_table[next_ip], ttl
	end

	# ARP

	def send_arp_request port, ip_dest
		puts "ARP_REQUEST|#{port.mac},FF:FF:FF:FF:FF:FF|#{port.ip},#{ip_dest}"
		neighbors.each do |neighbor|
			neighbor.receive_arp_request self, port, ip_dest
		end

	end

	def receive_arp_request origin, origin_port, ip_dest
		if has_ip ip_dest
			port = get_port ip_dest
			send_arp_reply port, origin, origin_port
		end
	end

	def send_arp_reply port, origin, origin_port
		puts "ARP_REPLY|#{port.mac},#{origin_port.mac}|#{port.ip},#{origin_port.ip}"
		arp_table[origin_port.ip] = origin_port.mac
		origin.receive_arp_reply self, port
	end

	def receive_arp_reply origin, port
		arp_table[port.ip] = port.mac
	end

	# ICMP

	def send_icmp_request ip_origin, ip_final, port_mac, mac_next, ttl
		puts "ICMP_ECHOREQUEST|#{port_mac},#{mac_next}|#{ip_origin},#{ip_final}|#{ttl}"
		destination = find_neighboor mac_next
		destination.receive_icmp_request ip_origin, ip_final, ttl - 1

	end

	def receive_icmp_request ip_origin, ip_final, ttl
		# not considering ttl == 0 for now
		send_message ip_origin, ip_final, ttl
	end

	def receive_icmp_reply ip_origin, ip_final, ttl
		send_message_back ip_origin, ip_final, ttl
	end

	def send_icmp_reply ip_origin, ip_final, port_mac, mac_next, ttl
		puts "ICMP_ECHOREPLY|#{port_mac},#{mac_next}|#{ip_origin},#{ip_final}|#{ttl}"
		destination = find_neighboor mac_next
		destination.receive_icmp_reply ip_origin, ip_final, ttl - 1
	end

	# Auxiliar Functions

	def has_mac mac
		ports.each do |port|
			if port.mac == mac
				return true
			end
		end
		return false
	end

	def has_ip ip
		ports.each do |port|
			if port.ip == ip
				return true
			end
		end
		return false
	end

	def get_port ip
		ports.each do |port|
			if port.ip == ip
				return port
			end
		end
		return nil
	end

	def has_network ip_dest
		ports.each do |port|
			port_net = addr_to_network port.ip, port.prefix
			ip_net = addr_to_network ip_dest, port.prefix
			if port_net == ip_net
				return true
			end
		end
		return false
	end

	def find_port_by_net ip_dest
		ports.each do |port|
			port_net = addr_to_network port.ip, port.prefix
			ip_net = addr_to_network ip_dest, port.prefix
			if port_net == ip_net
				return port
			end
		end
		return nil
	end

	def find_neighboor mac
		neighbors.each do |neigh|
			if neigh.is_a? Node
				if neigh.mac == mac
					return neigh
				end
			else
				if neigh.has_mac mac
					return neigh
				end
			end
		end
		return nil
	end

end
