
class RouterTable

	attr_accessor :entry_list

	def initialize
		@entry_list = Array.new
	end

	def to_s
		"#{entry_list.join}" #WHY DOES IT PRINT BEAUTIFULLY IN A NEW LINES??????
	end

	# incomplete
	def find_nexthop router, ip_dest
		entries = entry_list.select {|r| r.name == router.name}
		entries.each do |entry|
			net_dest = addr_to_network ip_dest, entry.prefix
			if net_dest == entry.net_dest
				return entry.next_hop
			end
		end
		return "anaue"
	end

end
