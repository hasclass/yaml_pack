require 'spec_helper'


describe YamlPack do
  it "should load empty file and return empty hash" do
    result = YamlPack.new('spec/fixtures/yaml_pack/empty.yml').load_deep_merged
    
    result.should == {}
  end

  it "should load one yaml file" do
    result = YamlPack.new('spec/fixtures/yaml_pack/names.yml').load_deep_merged
    
    result['countries']['ch']['name'].should == 'Switzerland'
  end

  it "should convert keys" do
    f = 'spec/fixtures/yaml_pack/names.yml'
    toolbox = YamlPack.new(f, :key_converter => Proc.new{|k| k.to_sym})
    result = toolbox.load_deep_merged
    result[:countries][:ch][:name].should == 'Switzerland'
  end


  it "should allow for key_converters with previous keys" do
    f = 'spec/fixtures/yaml_pack/names.yml'
    toolbox = YamlPack.new(f, :key_converter => Proc.new{|key, previous_keys| [previous_keys, key].flatten.join("_")})
    result = toolbox.load_deep_merged
    result['countries']['countries_ch']['countries_ch_name'].should == 'Switzerland'
  end


  it "should merge two yaml files" do
    files = [
      'spec/fixtures/yaml_pack/names.yml',
      'spec/fixtures/yaml_pack/population.yml'
    ]
    
    result = YamlPack.new(files).load_deep_merged

    # deep merge ch
    result['countries']['ch']['name'].should == 'Switzerland'
    result['countries']['ch']['population'].should == 8
    # items specific to population.yml
    result['countries']['it']['population'].should == 56
    # items specific to names.yml
    result['countries']['pl']['name'].should == 'Poland'
  end

  it "files should overwrite previous files" do
    files = [
      'spec/fixtures/yaml_pack/names.yml',
      'spec/fixtures/yaml_pack/names_german.yml'
    ]
    
    result = YamlPack.new(files).load_deep_merged
    result['countries']['ch']['name'].should == 'Schweiz'
  end

  it "replicate nesting of subfolders into resulting hash" do
    files = [
      'spec/fixtures/yaml_pack/names.yml',
      'spec/fixtures/yaml_pack/countries/sweden.yml'
    ]
    
    result = YamlPack.new(files, :base_dir => 'spec/fixtures/yaml_pack').load_deep_merged
    result['countries']['ch']['name'].should == 'Switzerland'
    result['countries']['se']['name'].should == 'Sweden'
  end


  it "#subfolders" do
    YamlPack.subfolders("/foo/", "/foo/baz.yml").should == []
    YamlPack.subfolders("/foo/", "/foo/bar/baz.yml").should == ['bar']
    YamlPack.subfolders("/foo/", "/foo/bar/baz/lorem.yml").should == ['bar', 'baz']

    YamlPack.subfolders("foo/", "foo/bar/baz.yml").should == ['bar']
    YamlPack.subfolders("/foo", "/foo/baz.yml").should == []
    YamlPack.subfolders("", "/foo/baz.yml").should == ['foo']
    YamlPack.subfolders(nil, "/foo/baz.yml").should == ['foo']
  end
end