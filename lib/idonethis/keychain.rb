module IDoneThis
  class KeyChain
    def self.add_generic_password(password)
      `security add-generic-password -a $USER -s idonethis -l "idonethis Gmail Password" -U -w "#{password}"`
    end
    def self.find_generic_password
      output = `security find-generic-password -a $USER -s idonethis -g 2>&1 >/dev/null`
      output[/^password: "(.*)"$/, 1]
    end
  end
end
