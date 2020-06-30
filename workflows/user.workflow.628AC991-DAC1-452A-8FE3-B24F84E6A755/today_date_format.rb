#! /usr/bin/env ruby

require 'json'

TimeFormat = Struct.new(:title, :value, :identifier) do
	def initialize(*args)
		super(*args.map(&:strip))
	end
	
	def to_h
		{
			:uid 					=> self.identifier,
			:title					=> self.title,
			:arg						=> self.value,
			:subtitle			=> self.value,
			:autocomplete	=> self.value,
		}
	end
	
	def to_json(*args)
		to_h.to_json
	end
end

FORMATS = [
	TimeFormat.new("Week Number", 			`date +%V`, 							"snippets.date.week_number"),
	TimeFormat.new("Time Zone", 				`date +%Z`, 							"snippets.date.time_zone"),
	TimeFormat.new("UTC", 							`date +%s`, 							"snippets.date.timestamp"),
	TimeFormat.new("File Safe Date", 	`date +%Y-%m-%d`, 				"snippets.date.file_safe_date"),
	TimeFormat.new("Daily Log Date", 	`date '+%Y-%m-%d, %A'`, 	"snippets.date.daily_log_date"),
]

puts ({:items => FORMATS}.to_json)