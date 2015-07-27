require 'test/unit'
require 'ebaw'
require 'tmpdir'

class TestFileMover < Test::Unit::TestCase
  class << self
    # テスト群の実行前に呼ばれる．変な初期化トリックがいらなくなる
    def startup
      @@tempdir = Dir.mktmpdir("ebaw_testsandbox")
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
    filemover = Ebaw::FileMover.new do |this|
      this.inputfile = @@inputfile
      this.outputfile = @@outputfile
      this.transfer_param(:outputfile)
    end
    outparams = filemover.execute()
    assert_true(!File.exist?(@@inputfile))
    assert_true(File.exist?(@@outputfile))
    assert_equal(@@outputfile, outparams[:outputfile])
  end

end
