require "rake_compiler_dock"

ENV["RUBY_CC_VERSION"] = RUBY_VERSION

def host(platform)
  case platform
  when "x64-mingw32"
    "x86_64-w64-mingw32"
  when "x86-mingw32"
    "i686-w64-mingw32"
  when "x86_64-linux"
    "x86_64-redhat-linux"
  when "x86-linux"
    "i686-redhat-linux"
  when /x86_64.*darwin/
    "x86_64-apple-darwin"
  when /a.*64.*darwin/
    "aarch64-apple-darwin"
  else
    raise "unmatched platform: #{platform}"
  end
end

task "cross-compile" do
  # libxar doesn't support windows:
  #  configure: error: can not detect the size of your system's uid_t type
  #  - x86-mingw32
  #  - x64-mingw32
  # configure.ac script need to be updated to support cross-compilation for:
  #  - arm64-darwin
  #  - x86_64-darwin
  %w(
    x86-linux
    x86_64-linux
  ).each do |platform|
    pre_req = case platform
              when /\linux/
                "sudo yum install -y git libxml2-devel libssl-devel"
              else
                "sudo apt-get update -y && sudo apt-get install -y automake autoconf libtool build-essential"
              end

    RakeCompilerDock.sh <<~EOS, platform: platform
      #{pre_req} &&
      gem install bundler --no-document &&
      bundle &&
      bundle exec rake compile[#{host(platform)}]
    EOS
  end
end