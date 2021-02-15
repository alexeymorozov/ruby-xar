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
  end

  def work_path
    File.join(super, "xar")
  end

  def configure
    Dir.chdir(work_path) do
      system("./autogen.sh --prefix=#{File.join(__dir__, "..", port_path)}")
    end
  end
end

recipe = XarRecipe.new
checkpoint = File.join(__dir__, "..", ".#{recipe.name}-#{RUBY_PLATFORM}-#{recipe.version}.installed")

CLEAN.include("ports", "tmp", checkpoint)

task :libxar do
  unless File.exist?(checkpoint)
    recipe.cook
    touch checkpoint
  end

  recipe.activate

  FileUtils.cp(File.join(__dir__, "..", recipe.port_path, "lib", "libxar.dylib"), "lib/xar/")
end