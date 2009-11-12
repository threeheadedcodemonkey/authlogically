Factory.define :inactive_user, :class => User do |u|
  u.name 'Joe User'
  u.login 'joe'
  u.email 'joe@bbt.com'
  u.password 'secret'
  u.password_confirmation 'secret'
end

Factory.define :user, :parent => :inactive_user do |u|
  u.active true
end

Factory.define :sheldon, :parent => :user do |u|
  u.name 'Sheldon Cooper'
  u.login 'sheldon'
  u.email 'sheldon@bbt.com'
end

Factory.define :short_login_leonard, :parent => :user do |u|
  u.name 'Leonard Hofstadter'
  u.login 'lh'
  u.email 'shortleonard@bbt.com'
end

Factory.define :long_login_leonard, :parent => :user do |u|
  u.name 'Leonard Hofstadter'
  u.login 'l0123456789012345678901234567890123456789'
  u.email 'longleonard@bbt.com'
end

Factory.define :leonard_not_active, :parent => :user do |u|
  u.name 'Leonard Hofstadter'
  u.login 'leonard'
  u.email 'longleonard@bbt.com'
  u.active false
end
