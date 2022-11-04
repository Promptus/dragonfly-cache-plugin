module Dragonfly
  module Cache
    module Adapter
      class Base
        attr_reader :public_path

        def initialize(public_path:)
          @public_path = public_path
        end

        def store(job)
          raise 'implement in subclass'
        end

        # you can override this in the subclass
        def url_for(app, job, opts)
          app.server.url_for(job, opts)
        end
      end
    end
  end
end
