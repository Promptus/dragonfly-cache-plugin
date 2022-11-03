require 'spec_helper'

RSpec.describe Dragonfly::Plugin::Cache::Local do

  let(:public_path) { test_server_root }
  let(:cache_path) { 'dragonfly-cache' }
  subject(:cache) { Dragonfly::Plugin::Cache::Local.new(public_path: public_path, cache_path: cache_path) }

  describe "::extract_sha" do
    let(:path) { File.join(cache_path, '3a87', 'image.jpg').to_s }

    subject { Dragonfly::Plugin::Cache::Local.extract_sha(path: path) }

    it { is_expected.to eql('3a87') }
  end

  describe "::extract_public_path" do
    let(:path) { File.join(public_path, cache_path, '3a87', 'image.jpg').to_s }

    subject { Dragonfly::Plugin::Cache::Local.extract_public_path(path: path, public_path: public_path) }

    it { is_expected.to eql('/dragonfly-cache/3a87/image.jpg') }
  end

  describe 'read_disk_cache' do
    let(:public_path) { test_server_root }
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
    let(:job) { double(:job, sha: '6a4bcf', basename: 'image', ext: 'webp' ) }
    subject { cache.job_cache_path(job) }

    it { is_expected.to eql(File.join(public_path, '/dragonfly-cache/6a4bcf/image.webp')) }
  end
end
