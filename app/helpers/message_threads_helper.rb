module MessageThreadsHelper
  MESSAGE_CONTROLLER_MAP = {
    "PhotoMessage" => "photos",
    "LinkMessage" => "links"
  }

  def thread_type(thread)
    if thread.private_to_group?
      t(".group_private", group: thread.group.name)
    elsif thread.group_id && thread.public?
      t(".group_public", group: thread.group.name)
    else
      t(".public")
    end
  end

  def message_controller_map(message)
    path = MESSAGE_CONTROLLER_MAP[message.class.to_s]
    raise "Message controller not found for #{message.class.to_s.inspect}" if path.nil?
    path
  end
end
