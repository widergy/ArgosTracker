module ArgosTracker
  class Config
    @config = {}

    class << self
      def set_config(api_key, source, product_name, url = 'https://argos.widergydev.com/v1/events/transactions')
        @config = {
          api_key: api_key,
          base_url: url,
          body: { source: source,
                  product: product_name }
        }
      end

      def get_config
        @config || {}
      end
    end
  end
end
