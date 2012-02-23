# Extend Hash with recursive merging abilities
class Hash
  # Deep merge method. Silly name prevents overwriting other implementations.
  #
  # Inspired from:
  # http://www.gemtacular.com/gemdocs/cerberus-0.2.2/doc/classes/Hash.html
  # File lib/cerberus/utils.rb, line 42
  def yaml_pack_deep_merge!(second)
    second.each_pair do |k,v|
      if self[k].is_a?(Hash) and second[k].is_a?(Hash)
        self[k].yaml_pack_deep_merge!(second[k])
      else
        self[k] = second[k]
      end
    end
  end
end