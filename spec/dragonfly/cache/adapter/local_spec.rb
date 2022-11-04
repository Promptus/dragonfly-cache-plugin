require 'spec_helper'

RSpec.describe Dragonfly::Cache::Adapter::Local do

  let(:public_path) { test_server_root }
  let(:cache_path) { 'dragonfly-cache' }
  subject(:cache) { Dragonfly::Cache::Adapter::Local.new(public_path: public_path, cache_path: cache_path) }

  describe "::extract_sha" do
    let(:path) { File.join(cache_path, '3a87', 'image.jpg').to_s }

    subject { Dragonfly::Cache::Adapter::Local.extract_sha(path: path) }

    it { is_expected.to eql('3a87') }
  end

  describe "::extract_public_path" do
    let(:path) { File.join(public_path, cache_path, '3a87', 'image.jpg').to_s }

    subject { Dragonfly::Cache::Adapter::Local.extract_public_path(path: path, public_path: public_path) }

    it { is_expected.to eql('/dragonfly-cache/3a87/image.jpg') }
  end

  describe 'read_disk_cache' do
    let(:cache_path) { 'static-cache' }

    subject { cache.read_disk_cache }

    it { expect(subject.size).to eql(2) }
    it { is_expected.to include('6a4bcf' => '/static-cache/6a4bcf/pexels-leigh-heasley-816294.jpg') }
    it { is_expected.to include('c2ff5a' => '/static-cache/c2ff5a/pexels-fox-212325.jpg') }


    describe 'cache' do
      subject { cache.cache }

      it { expect(subject.size).to eql(2) }
      it { is_expected.to include('6a4bcf' => '/static-cache/6a4bcf/pexels-leigh-heasley-816294.jpg') }
      it { is_expected.to include('c2ff5a' => '/static-cache/c2ff5a/pexels-fox-212325.jpg') }
    end
  end

  describe 'job_cache_path' do
    let(:job) { double(:job, sha: '6a4bcf', name: 'image.webp' ) }
    subject { cache.job_cache_path(job) }

    it { is_expected.to eql(File.join(public_path, '/dragonfly-cache/6a4bcf/image.webp')) }
  end

  describe 'url_for' do
    let(:job) { double(:job, sha: '6a4bcf' ) }
    let(:app) { double(:app, server: double(:server, url_for: '/media/UGI34a/dragonfly.jpg?712c78ae') ) }
    let(:opts) { {} }
    subject { cache.url_for(app, job, opts) }

    it { is_expected.to eql('/media/UGI34a/dragonfly.jpg?712c78ae') }

    context 'file is in the cache' do
      let(:cache_path) { 'static-cache' }

      it { expect(cache.cache[job.sha]).to eql('/static-cache/6a4bcf/pexels-leigh-heasley-816294.jpg') }
      it { is_expected.to eql('/static-cache/6a4bcf/pexels-leigh-heasley-816294.jpg') }
    end

    context 'file is not in the cache but on disk' do
      let(:cache_path) { 'static-cache' }

      before { cache.cache.clear }

      it { expect(cache.cache[job.sha]).to be_nil }
      it { is_expected.to eql('/static-cache/6a4bcf/pexels-leigh-heasley-816294.jpg') }
      it { expect { subject }.to change { cache.cache[job.sha] }.from(nil).to('/static-cache/6a4bcf/pexels-leigh-heasley-816294.jpg') }
    end
  end

  describe 'store' do
    let(:job) { Dragonfly.app.fetch('6a4bcf/pexels-leigh-heasley-816294.jpg') }
    let(:cache_file_path) { File.join(public_path, cache_path, '1dc2af4a00824a52/pexels-leigh-heasley-816294.jpg') }

    subject { cache.store(job) }

    before { FileUtils.rm_rf(File.join(public_path, cache_path)) }
    after { FileUtils.rm_rf(File.join(public_path, cache_path)) }

    it { expect { subject }.to change { File.exists?(cache_file_path) }.from(false).to(true) }
    it { expect { subject }.to change { cache.cache['1dc2af4a00824a52'] }.from(nil).to('/dragonfly-cache/1dc2af4a00824a52/pexels-leigh-heasley-816294.jpg') }

  end
end
