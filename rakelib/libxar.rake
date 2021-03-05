require "bundler/gem_tasks"
require "rspec/core/rake_task"
require "mini_portile2"
require "rake/clean"

class XarRecipe < MiniPortile

  public :port_path

  def initialize    
    super("libxar", "1.6.1")
    
    self.files << {
      url: "https://github.com/mackyle/xar/archive/xar-1.6.1.tar.gz",
      sha256: "5e7d50dab73f5cb1713b49fa67c455c2a0dd2b0a7770cbc81b675e21f6210e25"
    }

    self.patch_files = Dir[File.join(__dir__, "..", "patches", "*.patch")].sort
    @sysroot = "/"
  end

  def configure_defaults
    [
      "--host=#{@host}",
      "--build=x86_64-pc-mingw64",
#      "--sysroot=#{@sysroot}"
    ]
  end

  def configure_prefix
    "--prefix=#{File.expand_path(File.join(__dir__, "..", port_path))}"
  end

  def work_path
    File.join(super, "xar")
  end

  def configure
    autogen

    super
  end

  def autogen
    if RUBY_PLATFORM=~/mingw|mswin/
      # Windows doesn't recognize the shebang.
      execute('autogen', %w(sh ./autogen.sh --noconfigure))
    else
      execute('autogen', %w(./autogen.sh --noconfigure))
    end
  end
end

task :libxar, [:host, :sysroot] do |task, args|
  XarRecipe.new.tap do |recipe|
    recipe.host = args[:host] if args[:host]
    recipe.sysroot = args[:sysroot] if args[:sysroot]

    checkpoint = File.join(__dir__, "..", "ports", ".#{recipe.name}-#{recipe.host}-#{recipe.version}.installed")

    unless File.exist?(checkpoint)
      recipe.cook
      touch checkpoint
    end

    recipe.activate

    FileUtils.cp_r(
      Dir.glob(File.join(__dir__, "..", recipe.port_path, "lib", "*")).grep(/\/(?:lib)?[a-zA-Z]+\.(?:so|dylib|dll)$/),
      "lib/xar/",
      verbose: true
    )
  end
end

CLEAN.include("ports", "tmp")
''