#! /usr/bin/env ruby

require 'json'

CommandOutput = Struct.new(:title, :command, :identifier) do
	def initialize(*args)
		super(*args.map(&:strip))
	end
	
	def to_h
		{
			:uid 		=> self.identifier,
			:title		=> self.title,
			:arg		=> self.command,
			:subtitle	=> self.command,
			:autocomplete	=> self.command,
		}
	end
	
	def to_json(*args)
		output = `#{self.command}`
		success = $?.success?

		unless success
			return nil
		end
		
		self.command = output.chomp

		to_h.to_json
	end
end

sed_command = "echo '#{ENV["input"]}' | #{ARGV[0]}"

OUTPUT = [
	CommandOutput.new("", sed_command, ""),
]

puts ({:items => OUTPUT}.to_json)
