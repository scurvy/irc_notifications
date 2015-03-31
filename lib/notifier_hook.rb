require 'irc'

class NotifierHook < Redmine::Hook::ViewListener

  def controller_issues_new_after_save(context = { })
    @project = context[:project]
    @project_id = context[:request].parameters[:project_id]
    @issue = context[:issue]
    @journal = context[:journal]
    @user = @issue.author
    msg = "#{@user.login} created issue #{@issue.subject}"
    msg += ": #{truncate_single_line_raw(@issue.description, 100)}" unless @issue.description.empty?
    msg += " (#{redmine_url(@issue.event_url(:only_path => false))})"
    Irc.speak(msg, @project_id)
    #say msg
  end
  
  def controller_issues_edit_after_save(context = { })
    @project = context[:project]
    @project_id = context[:request].parameters[:project_id]
    @issue = context[:issue]
    @journal = context[:journal]
    @user = @journal.user
    if @issue.closed? == true
      msg = "#{@user.login} closed issue #{@issue.subject}"
    elsif @issue.reopened? == true
      msg = "#{@user.login} reopened issue #{@issue.subject}"
    else
      msg = "#{@user.login} updated issue #{@issue.subject}"
    end
    msg += ": #{truncate_single_line_raw(@journal.notes, 100)}" unless @journal.notes.empty?
    msg += " (#{redmine_url(@issue.event_url(:only_path => false))})"
    Irc.speak(msg, @project_id)
    #say msg
  end

  def controller_messages_new_after_save(context = { })
    @project = context[:project]
    @project_id = context[:request].parameters[:project_id]
    @message = context[:message]
    @user = @message.author
    Irc.speak("#{@user.login} wrote a new message #{@message.subject} on #{@project.name}: #{truncate_single_line_raw(@message.content, 100)} (#{redmine_url(@message.event_url(:only_path => false))})", @project_id)
    #say "#{@user.login} wrote a new message #{@message.subject} on #{@project.name}: #{truncate_single_line_raw(@message.content, 100)} (#{redmine_url(@message.event_url(:only_path => false))})"
  end
  
  def controller_messages_reply_after_save(context = { })
    @project = context[:project]
    @project_id = context[:request].parameters[:project_id]
    @message = context[:message]
    @user = @message.author
    Irc.speak("#{@user.login} replied a message #{@message.subject} on #{@project.name}: #{truncate_single_line_raw(@message.content, 100)} (#{redmine_url(@message.event_url(:only_path => false))})", @project_id)
    #say "#{@user.login} replied a message #{@message.subject} on #{@project.name}: #{truncate_single_line_raw(@message.content, 100)} (#{redmine_url(@message.event_url(:only_path => false))})"
  end
  
  def controller_wiki_edit_after_save(context = { })
    @project = context[:project]
    @project_id = context[:request].parameters[:project_id]
    @page = context[:page]
    @user = @page.content.author
    Irc.speak("#{@user.login} edited the wiki #{@page.pretty_title} on #{@project.name} (#{redmine_url(@page.event_url(:only_path => false))})", @project_id)
    #say "#{@user.login} edited the wiki #{@page.pretty_title} on #{@project.name} (#{redmine_url(@page.event_url(:only_path => false))})"
  end

private
  def redmine_url(param)
    param[:host] = Setting.host_name
    param[:protocol] = Setting.protocol
    url_for(param)
  end

  def say(message)
    begin
      Irc.speak message
    rescue => e
      puts "Error during IRC notification: #{e.message}"
    end
  end
end
