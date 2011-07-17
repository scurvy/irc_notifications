require 'redmine'
require_dependency 'notifier_hook'
require_dependency 'irc'

Redmine::Plugin.register :redmine_irc_notifications do
  name 'IRC Notifications plugin'
  author 'Richard Hesse'
  description 'A plugin to send updates to IRC'
  version '0.1'
end
