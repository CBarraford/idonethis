require 'net/smtp'

module IDoneThis
  module Senders
    class GmailSender
      def send(message)
        Gmail.new(IDoneThis.config.username, IDoneThis.config.password) do |gmail|
          gmail.deliver do
            to IDoneThis.config.idonethis_address
            subject 'What I did today'
            text_part do
              body message
            end
          end
        end
      end
    end
  end
end