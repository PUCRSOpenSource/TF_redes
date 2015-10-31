
class RouterTableEntry

	attr_accessor :name
	attr_accessor :net_dest
	attr_accessor :prefix
	attr_accessor :next_hop
	attr_accessor :port

	def to_s
		"#{name},#{net_dest}/#{prefix},#{next_hop},#{port}"
	end

end
