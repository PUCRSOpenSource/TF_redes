
class Router

	attr_accessor :name
	attr_accessor :ports
	attr_accessor :arp_table
	attr_accessor :neighbors

	def to_s
		"#{name},#{ports.size},#{ports.join ','}"
	end

	def arp_request ip
	end

	def arp_reply origin, port
		puts "ARP_REPLY|#{port.mac},#{origin.mac}|#{port.ip},#{origin.ip}"
		origin.arp_table[port.ip] = port.mac	
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

end
