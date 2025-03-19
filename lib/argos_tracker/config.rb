module ArgosTracker
  class Config
    @config = {}

    class << self
      def set_config(product, api_key, source, product_name, enviroment = 'development')
        url = get_url(enviroment)

        @config[product] = {
          api_key: api_key,
          base_url: url,
          body: { source: source,
                  product: product_name }
        }
      end

      def get_url(environment)
        case environment
        when 'development'
          'https://argos.widergydev.com/v1'
        when 'production'
          'https://argos.widergy.com/v1'
        when 'staging'
          'https://argos.widergydev.com/v1'
        else
          'https://argos.widergydev.com/v1'
        end
      end

      def get_config(product)
        @config[product] || {}
      end
    end
  end
end
