require "spec_helper"

RSpec.describe Xar::Native do
  describe ".xar_open" do
    # let(:path) { fixture_path("test.xar") }
    let(:path) { "/Users/amorozov/Downloads/microsoft_excel_15.11.1_updater.pkg" }

    context "given ttc file" do
      it "opens xar file" do
        archive = Xar::Native.xar_open(path, :read)
        iter = Xar::Native.xar_iter_new_fixed
        file = Xar::Native.xar_file_first(archive, iter)
        puts file
        Xar::Native.xar_close(archive)
      end
    end
  end

  def fixture_path(filename)
    File.join(__dir__, "fixtures", filename)
  end
end
