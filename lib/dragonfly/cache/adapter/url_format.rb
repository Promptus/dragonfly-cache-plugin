module Dragonfly
  module Cache
    module Adapter
      class UrlFormat < Base
        attr_reader :public_path, :url_format, :cache

        def initialize(public_path:, url_format:)
          super(public_path: public_path)
          @url_format = url_format
        end

        def job_cache_path(job)
          segments = url_format.split('/').map do |segment|
            if (method_name = segment[/:(\w+)/, 1])
              job.public_send(method_name)
            else
              segment
            end
          end
          File.join(public_path, *segments)
        end

        def store(job)
          fullpath = job_cache_path(job)
          job.to_file(fullpath, mode: 0644) unless File.exists?(fullpath)
        end
      end
    end
  end
end
