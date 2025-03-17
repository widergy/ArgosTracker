module ArgosTracker
  class Config
    @config = {}

    class << self
      def set_config(product, api_key, source, product_name)
        @config[product] = {
          api_key: api_key,
          source: source,
          product: product_name
        }
      end

      def get_config(product)
        @config[product] || {}
      end
    end
  end
end
