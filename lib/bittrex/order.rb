module Bittrex
  class Order
    attr_reader :type, :id, :limit,
                :exchange, :price, :quantity, :remaining,
                :total, :fill, :executed_at, :raw

    def initialize(attrs = {})
      @id = attrs['Id'] || attrs['OrderUuid'] if ( attrs['Id'] || attrs['OrderUuid']).present?
      @type = (attrs['Type'] || attrs['OrderType']).to_s.capitalize if (attrs['Type'] || attrs['OrderType']).present?
      @exchange = attrs['Exchange'] if attrs['Exchange'].present?
      @quantity = attrs['Quantity'] if attrs['Quantity'].present?
      @remaining = attrs['QuantityRemaining'] if attrs['QuantityRemaining'].present?
      @price = attrs['Rate'] || attrs['Price'] if (attrs['Rate'] || attrs['Price']).present?
      @total = attrs['Total'] if attrs['Total'].present?
      @fill = attrs['FillType'] if attrs['FillType'].present?
      @limit = attrs['Limit'] if attrs['Limit'].present?
      @commission = attrs['Commission'] if attrs['Commission'].present?
      @raw = attrs
      @executed_at = Time.parse(attrs['TimeStamp']) if attrs['TimeStamp'].present?
    end

    def self.book(market, type, depth = 50)
      orders = []

      if type.to_sym == :both
        orderbook(market, type.downcase, depth).each_pair do |type, values|
          values.each do |data|
            orders << new(data.merge('Type' => type))
          end
        end
      else
        orderbook(market, type.downcase, depth).each do |data|
          orders << new(data.merge('Type' => type))
        end
      end

      orders
    end

    def self.open
      client.get('market/getopenorders').map{|data| new(data) }
    end

    def self.history
      client.get('account/getorderhistory').map{|data| new(data) }
    end

    private

    def self.orderbook(market, type, depth)
      client.get('public/getorderbook', {
        market: market,
        type: type,
        depth: depth
      })
    end

    def self.client
      @client ||= Bittrex.client
    end
  end
end
