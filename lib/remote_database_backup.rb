require 'rubygems'
require 'popen4'
require 'shellwords'


module RemoteDatabaseBackup
  module_function
  
  def list_tables( database )
    command = ['mysql', 
            '-u', database["user"],
            '-p'+database["password"],
            '-h', database["hostname"],
            "-e","SHOW TABLES",
            config["database"]].shelljoin
    status = POpen4::popen4(command) do |stdout, stderr|
              error = stderr.read
              if not error.empty?
                throw error
              end
      
              results = stdout.read.split("\n")
              results.delete_at(0)
              return results.sort
            end
  end
  
  def clear_staging_area(config)
    staging=config['staging']
    Dir.new(staging).each do | filename |
      next if ['.','..'].include? filename
      File.delete(filename)
    end
  end
end