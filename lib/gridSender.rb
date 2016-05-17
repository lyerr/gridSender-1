require 'sendgrid-ruby'
require 'smtpapi'
require 'YAML'

module GridSender

#read in config file
varArray = YAML.load(File.read("config.txt"))

# Authenticate via Sendgrid API Key
client = SendGrid::Client.new(api_key: varArray['apiKey'])
#get command line variables 
fromAddress = varArray['fromAddress']
subject = varArray['subject']
category = varArray['category']

# load template file
message = File.read(varArray['templateFile'])

@blue = []
@red = []
#make the files enumerable. 
file_1 = File.open(varArray['emailsFile'], 'r').to_enum
file_2 = File.open(varArray['uidsFile'], 'r').to_enum

loop do
  email = file_1.next
  uid = file_2.next

#create message and send
    mail = SendGrid::Mail.new do |m|
      header = Smtpapi::Header.new
      header.add_substitution('uid', [uid])
      header.add_category(category)
      m.to = email
      m.from = fromAddress
      m.subject = subject
      m.html = message
      m.smtpapi = header
    end

    res = client.send(mail)
    puts "Email: #{email} -- UID: #{uid} --  Status Code: #{res.code}"
  end
end
