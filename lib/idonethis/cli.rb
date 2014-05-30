require 'thor'
require 'tempfile'
require 'colorize'

module IDoneThis
  class Cli < Thor
    package_name 'IDoneThis'

    desc 'task', 'add finished task to idonethis'
    option :editor, type: :boolean, default: false, aliases: '-e'
    option :message, aliases: '-m'
    def task
      if options[:editor]
        temp_file = Tempfile.new('idonethis_task')
        editor = ENV['EDITOR'] || 'vi'
        system "#{editor} #{temp_file.path}"
        msg = File.read(temp_file.path)
        if msg.length > 0
          IDoneThis.send(msg)
          puts 'Sent task'.green
        else
          puts 'No contents to send, exiting...'.red
        end
      else
        IDoneThis.send(options[:message])
        puts 'Sent task'.green
      end
    end
    default_task :task

    desc 'configure', 'configure idonethis'
    option :username, desc: 'your gmail email address', aliases: '-u'
    option :password, desc: 'your gmail password', aliases: '-p'
    option :team, desc: 'your idonethis team name or idonethis team email address', aliases: '-t'
    def configure
      puts 'Configure idonethis'.magenta
      puts '-------------------'.magenta

      username = options[:username] || nil
      password = options[:password] || nil
      team = options[:team] || nil

      username = ask_username unless username

      # get the password via input
      # have the user write it twice to make sure we have the correct password
      unless password
        # figure out if we should store the gmail password locally
        if RUBY_PLATFORM.downcase.include?('darwin')
          # always store password on Macs, they store in the keychain
          store_password = true
        else
          puts 'Store gmail password in configuration file? (y/n)'.yellow
          store_password = STDIN.gets.strip.downcase == 'y'
        end
        if store_password
          passwd1, passwd2 = 1, 2 # init passwd vars so they don't match
          while passwd1 != passwd2
            passwd1 = IDoneThis.get_password('Your Gmail password: ')
            passwd2 = IDoneTHis.get_password('Your Gmail password (again): ')
            puts 'Passwords do not match, try again'.red if passwd1 != passwd2
          end
          password = passwd1
        end
      end

      unless team
        puts 'Your IDoneThis team name ( or full email address ): '.yellow
        team = STDIN.gets.strip
        team += '@team.idonethis.com' unless team =~ /@/
      end

      IDoneThis.config.username = username
      IDoneThis.config.password = password unless password
      IDoneThis.config.idonethis_address = team
      IDoneThis.config.sender = 'GmailSender'
      IDoneThis.config.save

      puts "Done! Call idonethis -m \"message\" to tell IDoneThis what you done did.".green
    end

    no_tasks do
      def ask_username
        username = nil
        puts 'Your Gmail email address: '.yellow
        regex = username =~ "^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}$"
        until username =~ /#{regex}/i ? true : false
          username = STDIN.gets.strip
          # check if email address given is valid email
          puts 'Invalid email address, try again'.red unless username =~ /#{regex}/i
        end
        username
      end
    end
  end
end
