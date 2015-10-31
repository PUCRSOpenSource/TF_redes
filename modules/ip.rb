
module Ip

	def addr_to_dec addr
		addr.split('.').inject(0) { |total,value| (total << 8 ) + value.to_i }
	end

	def dec_to_addr num
		[24, 16, 8, 0].collect { |b| (num >> b) & 255 }.join('.')
	end

	def addr_to_network ip, prefix
		addr_dec = addr_to_dec ip
		net_dec = (0xFFFFFFFF << (32 - prefix)) & addr_dec
		dec_to_addr net_dec
	end

end
