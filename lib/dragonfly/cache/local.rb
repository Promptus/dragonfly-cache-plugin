module Dragonfly
  module Cache
    class Local

      class << self
        def extract_sha(path:)
          path.to_s.split('/')[-2]
        end

        def extract_public_path(path:, public_path:)
          path[/#{public_path}(.+)/, 1]
        end
      end

      attr_reader :public_path, :cache_path, :cache

      def initialize(public_path:, cache_path: 'dragonfly-cache')
        @public_path = public_path
        @cache_path = cache_path
        FileUtils.mkdir_p(File.join(public_path, cache_path))
        @cache = read_disk_cache
      end

      def read_disk_cache
        c = {}
        Dir[File.join(public_path, cache_path, '*', '*')].each do |path|
          sha = self.class.extract_sha(path: path)
          c[sha] = self.class.extract_public_path(path: path, public_path: public_path)
        end
        c
      end

      def job_cache_path(job)
        File.join(public_path, cache_path, job.sha, [job.basename, job.ext].join('.'))
      end

      def store(job)
        fullpath = job_cache_path(job)
        @cache[job.sha] = self.class.extract_public_path(path: fullpath, public_path: public_path)
        job.to_file(fullpath, mode: 0644) unless File.exists?(fullpath)
      end

      def url_for(app, job, opts)
        sha = job.sha
        if (path = @cache[sha])
          path
        elsif (fullpath = Dir[File.join(public_path, cache_path, sha, '*')].first)
          @cache[sha] = self.class.extract_public_path(path: fullpath, public_path: public_path)
        else
          app.server.url_for(job, opts)
        end
      end
    end
  end
end
