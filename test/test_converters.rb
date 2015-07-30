require 'test/unit'
require 'magicshelf'
require 'tmpdir'

class TestFileMover < Test::Unit::TestCase
  class << self
    # テスト群の実行前に呼ばれる．変な初期化トリックがいらなくなる
    def startup
      @@tempdir = Dir.mktmpdir("magicshelf_testsandbox")
      @@inputfile = File.join(@@tempdir,'test_inputfile')
      File.open(@@inputfile,'w')
      @@outputfile = File.join(@@tempdir,'test_outputfile')
    end

    # テスト群の実行後に呼ばれる
    def shutdown
      FileUtils.remove_entry_secure @@tempdir
    end
  end

  # 毎回テスト実行前に呼ばれる
  def setup
  end

  # テストがpassedになっている場合に，テスト実行後に呼ばれる．テスト後の状態確認とかに使える
  def cleanup
  end

  # 毎回テスト実行後に呼ばれる
  def teardown
  end

  def test_filemover
    filemover = MagicShelf::FileMover.new do |this|
      this.inputfile = @@inputfile
      this.outputfile = @@outputfile
    end
    outparams = filemover.execute()
    assert_true(!File.exist?(@@inputfile))
    assert_true(File.exist?(@@outputfile))
  end

end
