
class Router

	attr_accessor :name
	attr_accessor :ports
	attr_accessor :arp_table

	def to_s
		"#{name},#{ports.size},#{ports.join ','}"
	end

end
