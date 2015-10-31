
class Node

	attr_accessor :name
	attr_accessor :mac
	attr_accessor :ip
	attr_accessor :prefix
	attr_accessor :gateway
	attr_accessor :arp_table

	def to_s
		"#{name},#{mac},#{ip}/#{prefix},#{gateway}"
	end

end
