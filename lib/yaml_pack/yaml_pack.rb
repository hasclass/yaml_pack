class YamlPack

  KEY_CONVERTERS = {
    :symbolize => Proc.new{|key, previous_keys| key.respond_to?(:to_sym) ? key.to_sym : key }
  }.freeze
  
  attr_reader :files, :base_dir

  def initialize(files, opts = {})
    @files = [files].flatten

    @base_dir      = opts.fetch(:base_dir,      nil)
    @with_erb      = opts.fetch(:erb,           true)
    @key_converter = opts.fetch(:key_converter, nil)
    @header_file   = opts.fetch(:header_file,   nil)

    if KEY_CONVERTERS.has_key?(@key_converter)
      @key_converter = KEY_CONVERTERS[@key_converter]
    end
  end

  def load_deep_merged
    hsh = {}
    
    files.select{|f| File.exists?(f) }.each do |f|
      content = self.content(f)
      content = ERB.new(content).result(binding) if @with_erb
      
      result = YAML::load(content) || {}
      result = add_subfolders_as_namespaces(f, result) if @base_dir
      result = convert_keys_recursive(result) if @key_converter
      
      Util.deep_merge!(hsh, result)
    end

    hsh
  end

  # Include the contents of given file into yaml template.
  # Use this inside your yaml-file.
  #
  #    <%= include_file('/path/to/file.yml') %>
  #
  # DEBT: extract into own module/class
  #
  def include_file(file_path)
    File.read(file_path)
  end

  def content(file_path)
    body   = File.read(file_path) || ""
    [header, body].join("\n")
  end

  def header
    (@header_file && File.exists?(@header_file)) ? File.read(@header_file) : ""
  end

protected

  def convert_keys_recursive(result, previous_keys = [])
    if result.is_a?(Hash)
      hsh = {}
      result.each do |key, value|
        converted_key = @key_converter.call(key, previous_keys)
        hsh[converted_key] = convert_keys_recursive(value, [*previous_keys, key])
      end
      hsh
    else # If it's not a hash, return the object itself (end of recursion)
      result
    end
  end

  def add_subfolders_as_namespaces(file_path, object)
    Util.subfolders(base_dir, file_path).inject(object) do |object, subfolder|
      {subfolder => object}
    end
  end
end