
class Node

	attr_accessor :name
	attr_accessor :mac
	attr_accessor :ip
	attr_accessor :prefix
	attr_accessor :gateway
	attr_accessor :arp_table
	attr_accessor :neighbors

	def to_s
		"#{name},#{mac},#{ip}/#{prefix},#{gateway}"
	end

	def initialize
		@arp_table = Hash.new
		@neighbors = Array.new
	end

	# Messages abstraction

	def send_message ip_dest, ttl
		dest_network = addr_to_network ip_dest, prefix
		my_network = addr_to_network ip, prefix

		if dest_network == my_network
			destination = ip_dest
		else
			destination = gateway
		end

		if !arp_table.has_key?(destination)
			send_arp_request destination
		end
		send_icmp_request ip, ip_dest, arp_table[destination], ttl
	end

	def send_message_back ip_dest
		dest_network = addr_to_network ip_dest, prefix
		my_network = addr_to_network ip, prefix

		if dest_network == my_network
			destination = ip_dest
		else
			destination = gateway
		end

		if !arp_table.has_key?(destination)
			send_arp_request destination
		end

		send_icmp_reply ip, ip_dest, arp_table[destination], 8
	end

	# ARP

	def send_arp_request ip_dest
		puts "ARP_REQUEST|#{mac},FF:FF:FF:FF:FF:FF|#{ip},#{ip_dest}"
		neighbors.each do |neighbor|
			neighbor.receive_arp_request self, self, ip_dest
		end
	end

	def receive_arp_request origin, port, ip_dest
		if ip == ip_dest
			send_arp_reply origin, port
		end
	end

	def send_arp_reply origin, port
		puts "ARP_REPLY|#{mac},#{port.mac}|#{ip},#{port.ip}"
		arp_table[port.ip] = port.mac
		origin.receive_arp_reply self, self
	end

	def receive_arp_reply origin, port
		arp_table[port.ip] = port.mac
	end

	# ICMP

	def send_icmp_request ip_origin, ip_final, mac_next, ttl
		puts "ICMP_ECHOREQUEST|#{mac},#{mac_next}|#{ip_origin},#{ip_final}|#{ttl}"
		destination = find_neighboor mac_next
		destination.receive_icmp_request ip_origin, ip_final, ttl - 1
	end

	def receive_icmp_request ip_origin, ip_final, ttl
		if ip == ip_final
			send_message_back ip_origin
		end
	end

	def send_icmp_reply ip_origin, ip_final, mac_next, ttl
		puts "ICMP_ECHOREPLY|#{mac},#{mac_next}|#{ip_origin},#{ip_final}|#{ttl}"
		destination = find_neighboor mac_next
		destination.receive_icmp_reply ip_origin, ip_final
	end

	def receive_icmp_reply ip_origin, ip_final
	end

	# Auxiliar Functions

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
