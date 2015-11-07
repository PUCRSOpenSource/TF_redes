
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

	def send_message ip_dest
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

		send_icmp_request arp_table[destination], ip_dest
	end

	# ARP

	def send_arp_request ip_dest
		puts "ARP_REQUEST|#{mac},FF:FF:FF:FF:FF:FF|#{ip},#{ip_dest}"
		neighbors.each do |neighbor|
			neighbor.receive_arp_request self, ip_dest
		end
	end

	def receive_arp_request origin, ip_dest
		if ip == ip_dest
			send_arp_reply origin
		end
	end

	def send_arp_reply origin
		puts "ARP_REPLY|#{mac},#{origin.mac}|#{ip},#{origin.ip}"
		origin.receive_arp_reply self
	end

	def receive_arp_reply origin
		arp_table[origin.ip] = origin.mac
	end

	# ICMP

	def send_icmp_request mac_next, ip_final
		puts "ICMP_REQUEST|#{mac},#{mac_next}|#{ip},#{ip_final}"
		destination = find_neighboor mac_next
		puts destination
		destination.receive_icmp_request self, ip_final
	end

	def receive_icmp_request origin, ip_final
		if ip == ip_final
			puts "é nos"
		end
	end

	def send_icmp_reply
	end

	def receive_icmp_reply
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
