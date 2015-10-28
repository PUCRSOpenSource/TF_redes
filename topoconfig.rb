def addr_to_dec addr
  addr.split('.').inject(0) { |total,value| (total << 8 ) + value.to_i }
end

def dec_to_addr num
  [24, 16, 8, 0].collect { |b| (num >> b) & 255 }.join('.')
end

class Node
	attr_accessor :name       #node name
	attr_accessor :mac        #node mac address
	attr_accessor :ip         #node ip adress
	attr_accessor :prefix     #node ip address prefix, works as a mask to get net address from ip
                            #example: ip address 10.0.0.1
                            #       prefix /24 (10.0.0.1/24)
                            #       net address = 10.0.0.1 && 255.255.255.0 = 10.0.0.0
	attr_accessor :gateway    #router connected to this node
	attr_accessor :arp_table  #node's arp table (known mac addresses from ip adressess)
end

class RouterPort
	attr_accessor :number     #port number
	attr_accessor :mac        #port mac address
	attr_accessor :ip         #port ip address
	attr_accessor :prefix     #port ip address prefix
end

class Router
	attr_accessor :name       #name
	attr_accessor :ports      #list of router ports
	attr_accessor :arp_table  #router's arp table
end

class RouterTableEntry
	attr_accessor :name       #router name
	attr_accessor :net_dest   #network destination. the network this entry is explaining how to get to
	attr_accessor :prefix     #network destination prefix
	attr_accessor :next_hop   #next router to access when looking for this network (0.0.0.0 if accessable from this address)
	attr_accessor :port       #port that have access to this network
end

class RouterTable
	attr_accessor :entry_list #list of entries
end

class ArpTable
	attr_accessor :ip_to_mac  #dictionary with ips as keys and mac addresses as values known by this element
end

ip_dictionary = Hash.new()

def create_dummy_stuff
	node = Node.new()
	node.name = "node1"
	node.mac = 1
	node.ip = "192.168.10.2"
	node.prefix = 24
	node.gateway = "192.168.0.1"

	router = Router.new()
	router.name = "router1"

	port = RouterPort.new()
	port.number = 1
	port.mac = 2
	port.ip = "192.168.0.1"
	port.prefix = 24

	router.ports = Array.new()
	router.ports << port

	ip_dictionary = {node.ip => node, port.ip => router}

end

def ping(ip1, ip2)

end

def traceroute(ip1, ip2)

end

if __FILE__ == $0
	# ip_dictionary = initialize a dictionary with all the existing ips being the keys and the objects related to it being the values
	file = File.new(ARGV.first, "r")
	type = ""
	while (line = file.gets)
    	puts line
	end
	file.close
	puts ip_dictionary

	create_dummy_stuff
end
