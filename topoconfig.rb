class Node
	attr_accessor :name
	attr_accessor :mac
	attr_accessor :ip
	attr_accessor :prefix
	attr_accessor :gateway
end

class Router
	attr_accessor :name
	attr_accessor :num_ports
	attr_accessor :mac_list
	attr_accessor :ip_list
	attr_accessor :prefix_list
end