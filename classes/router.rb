
class Router

	attr_accessor :name
	attr_accessor :ports
	attr_accessor :arp_table
	attr_accessor :neighbors

	def to_s
		"#{name},#{ports.size},#{ports.join ','}"
	end

	def initialize
		@arp_table = Hash.new
		@neighbors = Array.new
	end

	def receive_arp_request origin, ip_dest
		if has_ip ip_dest
			port = get_port ip_dest
			send_arp_reply port, origin
		end
	end

	def send_arp_reply port, origin
		puts "ARP_REPLY|#{port.mac},#{origin.mac}|#{port.ip},#{origin.ip}"
		origin.receive_arp_reply port
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

end
