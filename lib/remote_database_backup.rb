require 'rubygems'
require 'popen4'
require 'shellwords'


module RemoteDatabaseBackup
  module_function
  
  def clear_staging_area(config)
    staging=config['staging']
    `mkdir -p #{staging}`
    Dir.new(staging).each do | filename |
      next if ['.','..'].include? filename
      File.delete(config['staging']+'/'+filename)
    end
  end

  
  def download_database(database, config)
    clear_staging_area(config)
    staging=config['staging']
    command = ['mysqldump', 
            '--opt',
            '-u', database["user"],
            '-p'+database["password"],
            '-h', database["hostname"],
            database["database"]
            ].shelljoin + " > "+[staging+"/"+database['database']+'.sql'].shelljoin
    status = POpen4::popen4(command) do |stdout, stderr|
              error = stderr.read
              if not error.empty?
                throw error
              end
              return true
            end
  end
  
  def backup_database(database, config)
    download_database(database,config)
    staging=config['staging']
    destination=config['destination']+'/'+database['database']
    command = ['rdiff-backup',
                staging, destination].shelljoin
    status = POpen4::popen4(command) do |stdout, stderr|
              error = stderr.read
              if not error.empty?
                throw error
              end
              return true
            end  
    `rdiff-backup --remove-older-than 4W`
  end
  
  def backup_all_databases(databases, config)
    results = []
    all_success = true
    for database in databases
      begin
        backup_database(database, config)
        results.push [database['database'],true,'success']
      rescue
        results.push [database['database'],false,$!]
        all_success = false
      end
    end
    return all_success, results
  end
  
  def backup_all_databases_and_email(databases, config)
    success, results = backup_all_databases(databases, config)
    subject = (success ? "Successful" : "Failed")+ " Database Backup"
    message = ""
    message += "To: #{config['to_email']}\n"
    message += "From: #{config['from_email']}\n"
    message += "Subject: #{subject}\n"
    message += "Content-Type: text/html; charset=\"utf8\"\n"
    message += "\n"
    
    message += "<div style='font-family:Helvetica'><h2>Database Backup Results</h2>"
    for database, dbsuccess, why in results
      message +="<div style='clear:both'>"
      message +="<div style='clear:both'>"
      message +="<div style='float:left; width:5em; text-align:center; color: #fff; background: #{(dbsuccess ? '#FFCC33' : '#FF0000')}; font-size:.8em; -moz-border-radius: 2px; -webkit-border-radius: 2px; margin-right:6.em'>"+(dbsuccess ? 'success' : 'failure')+"</div>"
      message +="<span style='padding-left:.5em'>#{database} - #{why}</span>\n\n"
    end
    message += "</div>"
    
    return message
  end
end


#a