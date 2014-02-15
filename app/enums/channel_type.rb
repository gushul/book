class ChannelType < ActiveEnum::Base
  value :id => 0, :name => :unset
  value :id => 1, :name => :web
  value :id => 2, :name => :iphone
  value :id => 3, :name => :ipad
  value :id => 4, :name => :android
  value :id => 5, :name => :owner_mobile
end
