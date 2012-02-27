class YamlPack::Util

  def self.subfolders(base_dir, file_path)
    base_dir = "#{base_dir}/".gsub("//", '/') # hack to always have a trailing /
    file_path.gsub(/^#{base_dir}/, '').split('/')[0...-1]
  end

end