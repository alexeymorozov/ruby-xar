require "rubygems"
require "rake/extensiontask"

module Xar::Native
  extend FFI::Library

  # NOTE: ffi doesn't support bundles out of box https://github.com/ffi/ffi/issues/42#issuecomment-750031554
  # NOTE: rake-compiler doesn't support dylib generation https://github.com/rake-compiler/rake-compiler/issues/183
  lib_name = Rake::ExtensionTask.new("stripttc", Gem::Specification::load("../extract_ttc.gemspec")).binary(RUBY_PLATFORM)
  puts "Lib: #{lib_name}"
  ffi_lib File.join(File.dirname(__FILE__), lib_name)

  typedef :pointer, :xar_t
  typedef :pointer, :xar_file_t
  typedef :pointer, :xar_iter_t
  typedef :pointer, :xar_subdoc_t
  typedef :pointer, :xar_errctx_t

  callback :err_handler_callback, [:int32, :int32, :xar_errctx_t, :pointer], :int32

  FLAG = enum :read,  0,
              :write, 1

  attach_function :xar_open, [:string, FLAG], :xar_t
  attach_function :xar_close, [:xar_t], :void

  attach_function :xar_add, [:xar_t, :string], :xar_file_t
  attach_function :xar_add_frombuffer, [:xar_t, :xar_file_t, :string, :string, :size_t], :xar_file_t
  attach_function :xar_add_folder, [:xar_t, :xar_file_t, :string, FFI::Stat::Stat], :xar_file_t

  attach_function :xar_extract, [:xar_t, :xar_file_t], :int32

  attach_function :xar_register_errhandler, [:xar_t, :err_handler_callback, :pointer], :void
  attach_function :xar_err_get_file, [:xar_errctx_t], :xar_file_t
  attach_function :xar_err_get_string, [:xar_errctx_t], :string
  attach_function :xar_err_get_errno, [:xar_errctx_t], :int

  attach_function :xar_iter_new, [:void], :xar_iter_t
  attach_function :xar_iter_free, [:xar_iter_t], :void

  attach_function :xar_file_first, [:xar_t, :xar_iter_t], :xar_file_t
  attach_function :xar_file_next, [:xar_iter_t], :xar_file_t

  attach_function :xar_opt_set, [:xar_t, :string, :string], :int32
  attach_function :xar_opt_get, [:xar_t, :string], :string

  attach_function :xar_prop_set, [:xar_file_t, :string, :string], :int32
  attach_function :xar_prop_get, [:xar_file_t, :string, :pointer], :int32
  attach_function :xar_prop_first, [:xar_file_t, :xar_iter_t], :string
  attach_function :xar_prop_next, [:xar_iter_t], :string

  attach_function :xar_attr_set, [:xar_file_t, :string, :string, :string], :int32
  attach_function :xar_attr_get, [:xar_file_t, :string, :string], :string
  attach_function :xar_attr_first, [:xar_file_t, :string, :xar_iter_t], :string
  attach_function :xar_attr_next, [:xar_iter_t], :string

  attach_function :xar_subdoc_new, [:xar_t, :string], :xar_subdoc_t
  attach_function :xar_subdoc_prop_set, [:xar_subdoc_t, :string, :string], :int32
  attach_function :xar_subdoc_prop_get, [:xar_subdoc_t, :string, :pointer], :int32
  attach_function :xar_subdoc_first, [:xar_t], :xar_subdoc_t
  attach_function :xar_subdoc_next, [:xar_subdoc_t], :xar_subdoc_t
  attach_function :xar_subdoc_name, [:xar_subdoc_t], :string
  attach_function :xar_subdoc_copyout, [:xar_subdoc_t, :pointer, :pointer], :int32
  attach_function :xar_subdoc_copyin, [:xar_subdoc_t, :string, :int], :int32
  attach_function :xar_subdoc_remove, [:xar_subdoc_t], :void
end
