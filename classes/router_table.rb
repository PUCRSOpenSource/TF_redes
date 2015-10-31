
class RouterTable

	attr_accessor :entry_list

	def initialize
		@entry_list = Array.new
	end

	def to_s
		"#{entry_list.join}" #WHY DOES IT PRINT BEAUTIFULLY IN A NEW LINES??????
	end

end
