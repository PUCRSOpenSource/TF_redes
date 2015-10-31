
class RouterPort

	attr_accessor :mac
	attr_accessor :ip
	attr_accessor :prefix

	def to_s
		"#{mac},#{ip}/#{prefix}"
	end

end
