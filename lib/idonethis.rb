require 'hashie'
require 'active_support'
require 'gmail'

begin
  require 'io/console'
rescue LoadError
  # do nothing
end

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

  def self.get_password(prompt)
    if STDIN.respond_to?(:noecho)
      puts prompt.yellow
      STDIN.noecho(&:gets).strip
    else
      `read -s -p "#{prompt}" password; echo $password`.strip
    end
  end
end
