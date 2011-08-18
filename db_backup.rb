require 'yaml'


databases = YAML.load_file( 'databases.yaml' )
config = YAML.load_file( 'config.yaml' )


print backup_all_databases_and_email(databases,config)