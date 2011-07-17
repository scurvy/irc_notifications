class NotifierHook < Redmine::Hook::Listener

  PROTO='https'

  def controller_issues_new_after_save(context = { })
    @project = context[:project]
    @issue = context[:issue]
    @user = @issue.author
    say "#{@user.login} created issue “#{@issue.subject}” Comment: “#{truncate_words(@issue.description)}” #{PROTO}://#{Setting.host_name}/issues/#{@issue.id}"
  end
  
  def controller_issues_edit_after_save(context = { })
    @project = context[:project]
    @issue = context[:issue]
    @journal = context[:journal]
    @user = @journal.user
    if @issue.closed? == true
      say "#{@user.login} closed issue “#{@issue.subject}” Comment: “#{truncate_words(@journal.notes)}” #{PROTO}://#{Setting.host_name}/issues/#{@issue.id}"
    else if @issue.reopened? == true
      say "#{@user.login} reopened issue “#{@issue.subject}” Comment: “#{truncate_words(@journal.notes)}” #{PROTO}://#{Setting.host_name}/issues/#{@issue.id}"
    else
      say "#{@user.login} updated issue “#{@issue.subject}” Comment: “#{truncate_words(@journal.notes)}” #{PROTO}://#{Setting.host_name}/issues/#{@issue.id}"
    end
  end

  def controller_messages_new_after_save(context = { })
    @project = context[:project]
    @message = context[:message]
    @user = @message.author
    say "#{@user.login} wrote a new message “#{@message.subject}” on #{@project.name}: “#{truncate_words(@message.content)}”. #{PROTO}://#{Setting.host_name}/boards/#{@message.board.id}/topics/#{@message.root.id}#message-#{@message.id}"
  end
  
  def controller_messages_reply_after_save(context = { })
    @project = context[:project]
    @message = context[:message]
    @user = @message.author
    say "#{@user.login} replied a message “#{@message.subject}” on #{@project.name}: “#{truncate_words(@message.content)}”. #{PROTO}://#{Setting.host_name}/boards/#{@message.board.id}/topics/#{@message.root.id}#message-#{@message.id}"
  end
  
  def controller_wiki_edit_after_save(context = { })
    @project = context[:project]
    @page = context[:page]
    @user = @page.content.author
    say "#{@user.login} edited the wiki “#{@page.pretty_title}” on #{@project.name} #{PROTO}://#{Setting.host_name}/projects/#{@project.identifier}/wiki/#{@page.title}"
  end

private
  def say(message)
    begin
      Irc.speak message
    rescue => e
      puts "Error during IRC notification: #{e.message}"
    end
  end

  def truncate_words(text, length = 45, end_string = '…')
    return if text == nil
    words = text.split()
    words[0..(length-1)].join(' ') + (words.length > length ? end_string : '')
  end
end
