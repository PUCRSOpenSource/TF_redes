
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
	end

	def send_message ip_dest
		if !arp_table.has_key?(ip_dest)
			arp_request ip_dest
		end
		puts arp_table[ip_dest]
	end

	def arp_request ip_dest
		puts "ARP_REQUEST|#{mac},FF:FF:FF:FF:FF:FF|#{ip},#{ip_dest}"
		# Find Destination
		network = addr_to_network ip_dest, prefix
		my_network = addr_to_network ip, prefix

		if network != my_network
			destination = find_neighboor gateway
			dest_port = destination.get_port gateway
		else
			neighbors.each do |neigh|
				if neigh.is_a? Node
					if neigh.ip == ip_dest
						destination = neigh
					end
				end
			end
		end
		destination.arp_reply self, dest_port
	end

	def arp_reply origin, port
		puts "ARP_REPLY|#{mac},#{origin.mac}|#{ip},#{origin.ip}"
		origin.arp_table[ip] = mac
	end

	def find_neighboor ip
		neighbors.each do |neigh|
			if neigh.is_a? Node
				if neigh.ip == ip
					return neigh
				end
			else
				if neigh.has_ip ip
					return neigh
				end
			end
		end
		return nil
	end

end
