require 'hashie'
require 'active_support'
require 'gmail'

%w(
  idonethis/version
  idonethis/senders/gmail_sender
  idonethis/keychain
  idonethis/config
  idonethis/cli
).each do |c|
  begin
    require_relative "../lib/#{c}"
  rescue LoadError
    require c
  end
end

module IDoneThis
  def self.send(message)
    IDoneThis.config.sender.send(message)
  end
end
