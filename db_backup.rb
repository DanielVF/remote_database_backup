require 'yaml'
require 'lib/remote_database_backup'


databases = YAML.load_file( 'databases.yaml' )
config = YAML.load_file( 'config.yaml' )

puts RemoteDatabaseBackup.backup_all_databases_and_email(databases,config)