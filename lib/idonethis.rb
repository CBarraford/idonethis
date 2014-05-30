require 'hashie'
require 'active_support'
require 'gmail'

require 'idonethis/version'
require 'idonethis/senders/gmail_sender'
require 'idonethis/keychain'
require 'idonethis/config'

module IDoneThis
  def self.send(message)
    IDoneThis.config.sender.send(message)
  end
end
