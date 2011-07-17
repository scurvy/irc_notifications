IRC Notifications for Redmine
=============================

*Caveat* I'm a sysadmin. I cobbled this together in an hour from two other projects here on Github. I'm not making any claims to fame. I just needed this thing to work for my job.

This Redmine plugin will send update messages to IRC channels every time an issue, message, or wiki is updated. It's not fancy but it works. It's hacked
together from the following two projects:

http://github.com/edouard/redmine_campfire_notifications

https://github.com/mtah/redmine_irc_notifications  <-- This should work but it never did for me. Also doesn't support server passwords.

**Note:** The plugin won't actually `JOIN` your channel, so you need to either set `-n` on the channel or modify the code.

Because of this reason I wouldn't use it on public IRC networks unless you want to get banned. Use it only on private servers.

Installation
------------

-cd to the base of Redmine install

`cd /usr/local/redmine`

-Clone this project

`git clone http://github.com/scurvy/irc_notifications.git vendor/plugins/irc_notifications`

- copy irc.yml.example into config/irc.yml with your IRC settings

`cp vendor/plugins/irc_notifications/config/irc.yml.example config/irc.yml`

-Edit your config/irc.yml file with the appropriate settings. The use of the password is optional. If you're not using it, delete the line.

-Restart Redmine

Customization
-------------

Obivously you'll need to update the configuration file to work in your enviornment.

Also, in irc_notifications/lib/notifier_hook.rb, there's a constant named PROTO. That's used to control if you use http or https for Redmine.
It doesn't change functionality all that much, but gives you some customization when spitting out URLs. If you use HTTP, you'll need
to change the value to 'http' from 'https'.
