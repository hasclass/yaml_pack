class YamlPack::Util

  def self.subfolders(base_dir, file_path)
    base_dir = "#{base_dir}/".gsub("//", '/') # hack to always have a trailing /
    file_path.gsub(/^#{base_dir}/, '').split('/')[0...-1]
  end

  # Deep merge method. 
  #
  # Inspired from:
  # http://www.gemtacular.com/gemdocs/cerberus-0.2.2/doc/classes/Hash.html
  # File lib/cerberus/utils.rb, line 42
  def self.deep_merge!(first, second)
    second.each_pair do |k,v|
      if first[k].is_a?(Hash) and second[k].is_a?(Hash)
        deep_merge!(first[k], second[k])
      else
        first[k] = second[k]
      end
    end
  end
end