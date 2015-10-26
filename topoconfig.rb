class Node
	attr_accessor :name 		#node name
	attr_accessor :mac			#node mac address
	attr_accessor :ip			#node ip adress
	attr_accessor :prefix		#node ip address prefix, works as a mask to get net address from ip
								#example: ip address 10.0.0.1
								# 		  prefix /24 (10.0.0.1/24)
								# 		  net address = 10.0.0.1 && 255.255.255.0 = 10.0.0.0
	attr_accessor :gateway		#router connected to this node
end

class RouterPort
	attr_accessor :number		#port number
	attr_accessor :mac			#port mac address
	attr_accessor :ip			#port ip address
	attr_accessor :prefix		#port ip address prefix
end

class Router
	attr_accessor :name			#name
	attr_accessor :ports		#list of router ports
end

class RouterTableEntry
	attr_accessor :name			#router name
	attr_accessor :net_dest		#network destination. the network this entry is explaining how to get to
	attr_accessor :prefix		#network destination prefix
	attr_accessor :next_hop		#next router to access when looking for this network (0.0.0.0 if accessable from this address)
	attr_accessor :port 		#port that have access to this network
end

class RouterTable
	attr_accessor :entry_list	#list of entries
end