require 'net/smtp'

module IDoneThis
  module Senders
    class GmailSender
      def send(message)
        password = IDoneThis.config.password || nil
        password = IDoneThis.get_password('Gmail password: ') unless password # ask for password if not available
        Gmail.new(IDoneThis.config.username, password) do |gmail|
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
