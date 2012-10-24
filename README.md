# Idonethis

A simple little tool for sending IDoneThis messages.

# Setup

Install idonethis by running:

    gem install idonethis

Configure idonethis by calling:

    idonethis config

If you want to manually configure the gem, or change your configuration later, you can find it in `~/.idonethisrc`. Here's the options you can set:

* `username`: Your username on Gmail.
* `password`: Your password on Gmail.
* `sender`: Right now this needs to be set to 'GmailSender'. In the future we may add support for other e-mail providers.
* `idonethis_address`: The e-mail address you send idonethis messages to.

# Usage

Just call the following:

    idonethis "Talked to corporate - like a boss."

It'll be logged in your IDoneThis.
