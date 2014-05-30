require 'thor'
require 'tempfile'
require 'colorize'

begin
  require 'io/console'
rescue LoadError
  # do nothing
end

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
        passwd1, passwd2 = 1, 2 # init passwd vars so they don't match
        while passwd1 != passwd2
          passwd1 = get_password('Your Gmail password: ')
          passwd2 = get_password('Your Gmail password (again): ')
          puts 'Passwords do not match, try again'.red if passwd1 != passwd2
        end
        password = passwd1
      end

      unless team
        puts 'Your IDoneThis team name ( or full email address ): '.yellow
        team = STDIN.gets.strip
        team += '@team.idonethis.com' unless team =~ /@/
      end

      IDoneThis.config.username = username
      IDoneThis.config.password = password
      IDoneThis.config.idonethis_address = team
      IDoneThis.config.sender = 'GmailSender'
      IDoneThis.config.save

      puts "Done! Call idonethis -m \"message\" to tell IDoneThis what you done did.".green
    end

    no_tasks do
      def get_password(prompt)
        if STDIN.respond_to?(:noecho)
          puts prompt.yellow
          STDIN.noecho(&:gets).strip
        else
          `read -s -p "#{prompt}" password; echo $password`.strip
        end
      end

      def ask_username
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
