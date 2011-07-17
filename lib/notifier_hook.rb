class NotifierHook < Redmine::Hook::Listener

  def controller_issues_new_after_save(context = { })
    @project = context[:project]
    @issue = context[:issue]
    @user = @issue.author
    say "#{@user.firstname} created issue “#{@issue.subject}”. Comment: “#{truncate_words(@issue.description)}” http://#{Setting.host_name}/issues/#{@issue.id}"
  end
  
  def controller_issues_edit_after_save(context = { })
    @project = context[:project]
    @issue = context[:issue]
    @journal = context[:journal]
    @user = @journal.user
    say "#{@user.firstname} edited issue “#{@issue.subject}”. Comment: “#{truncate_words(@journal.notes)}”. http://#{Setting.host_name}/issues/#{@issue.id}"
  end

  def controller_messages_new_after_save(context = { })
    @project = context[:project]
    @message = context[:message]
    @user = @message.author
    say "#{@user.firstname} wrote a new message “#{@message.subject}” on #{@project.name}: “#{truncate_words(@message.content)}”. http://#{Setting.host_name}/boards/#{@message.board.id}/topics/#{@message.root.id}#message-#{@message.id}"
  end
  
  def controller_messages_reply_after_save(context = { })
    @project = context[:project]
    @message = context[:message]
    @user = @message.author
    say "#{@user.firstname} replied a message “#{@message.subject}” on #{@project.name}: “#{truncate_words(@message.content)}”. http://#{Setting.host_name}/boards/#{@message.board.id}/topics/#{@message.root.id}#message-#{@message.id}"
  end
  
  def controller_wiki_edit_after_save(context = { })
    @project = context[:project]
    @page = context[:page]
    @user = @page.content.author
    say "#{@user.firstname} edited the wiki “#{@page.pretty_title}” on #{@project.name}. http://#{Setting.host_name}/projects/#{@project.identifier}/wiki/#{@page.title}"
  end

private
  def say(message)
    begin
      Irc.speak message
    rescue => e
      puts "Error during IRC notification: #{e.message}"
    end
  end

  def truncate_words(text, length = 30, end_string = '…')
    return if text == nil
    words = text.split()
    words[0..(length-1)].join(' ') + (words.length > length ? end_string : '')
  end
end
