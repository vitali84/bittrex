module Bittrex
	class MarketHistory
		attr_reader :id, :quantity, :price, :total, :fill_type, :order_type, :created_at

		def initialize(attrs = {})
			@id        	 = attrs['Id']
			@quantity    = attrs['Quantity']
			@price       = attrs['Price']
			@total       = attrs['Total']
			@fill_type   = attrs['FillType']
			@order_type  = attrs['OrderType']
			@raw         = attrs
			@created_at  = Time.parse(attrs['TimeStamp'])
		end

		def self.current(market)
			client.get('public/getmarkethistory', market: market).to_a.map{|data| new( data) }
		end

		private

		def self.client
			@client ||= Bittrex.client
		end
	end
end
