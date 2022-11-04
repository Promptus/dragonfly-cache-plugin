require 'spec_helper'

RSpec.describe Dragonfly::Cache::Adapter::UrlFormat do

  let(:public_path) { test_server_root }
  let(:url_format) { '/media/:sha/:name' }
  subject(:cache) { Dragonfly::Cache::Adapter::UrlFormat.new(public_path: public_path, url_format: url_format) }


  describe 'job_cache_path' do
    let(:job) { double(:job, sha: '6a4bcf', name: 'image.webp', basename: "image" ) }
    subject { cache.job_cache_path(job) }

    it { is_expected.to eql(File.join(public_path, '/media/6a4bcf/image.webp')) }

    context 'different url format' do
      let(:url_format) { '/images/:sha/:basename' }

      it { is_expected.to eql(File.join(public_path, '/images/6a4bcf/image')) }
    end
  end

  describe 'store' do
    let(:job) { Dragonfly.app.fetch('6a4bcf/pexels-leigh-heasley-816294.jpg') }
    let(:cache_file_path) { File.join(public_path, 'media', '1dc2af4a00824a52/pexels-leigh-heasley-816294.jpg') }

    let(:clear_cache) { FileUtils.rm_rf(File.join(public_path, 'media')) }
    subject { cache.store(job) }

    before { clear_cache }
    after { clear_cache }

    it { expect { subject }.to change { File.exists?(cache_file_path) }.from(false).to(true) }

  end
end
