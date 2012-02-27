require 'spec_helper'

describe YamlPack::Util do
  it "#subfolders" do
    YamlPack::Util.subfolders("/foo/", "/foo/baz.yml").should == []
    YamlPack::Util.subfolders("/foo/", "/foo/bar/baz.yml").should == ['bar']
    YamlPack::Util.subfolders("/foo/", "/foo/bar/baz/lorem.yml").should == ['bar', 'baz']
    YamlPack::Util.subfolders("foo/", "foo/bar/baz.yml").should == ['bar']
    YamlPack::Util.subfolders("/foo", "/foo/baz.yml").should == []
    YamlPack::Util.subfolders("", "/foo/baz.yml").should == ['foo']
    YamlPack::Util.subfolders(nil, "/foo/baz.yml").should == ['foo']
  end
end