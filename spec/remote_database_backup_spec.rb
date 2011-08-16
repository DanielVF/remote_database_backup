require File.expand_path(File.dirname(__FILE__) + '/../lib/remote_database_backup.rb')
require 'yaml'

config = {'staging'=>'staging','destination'=>'target'}
dbs = YAML.load_file( 'test_databases.yaml' )
good_db = dbs['good_database']
other_db = dbs['other_good_database']
bad_db = dbs['bad_database']



Rdb = RemoteDatabaseBackup


describe 'RemoteDatabaseBackup' do
  

  describe "List remote tables" do
    subject { Rdb.list_tables(good_db) }
    its(:first) { should == "table b" }
    it { should have_at_least(2).items }
  end

  describe "clear staging area" do
    `touch staging/a.sql`
    p Dir.glob("staging/{*,.*}")
    Rdb.clear_staging_area(config)
    
    subject Dir.glob("staging/{*,.*}")
    it { should have(2).items }
  end

  describe "Download single table" do
    
    
    it "clears the staging directory before starting" do
      
    end
    
    it "has a bzipped table in the staging directory" do
      
    end
  end

  
  describe "Backups a downloaded database" do
    describe "success" do
      it "rsnapshot copys to target area" do
        
      end
    end
    describe "failure" do
      it "leave destination unchanged" do
        
      end
      it "mark failure" do
        
      end
    end
    
  end
  
  
  describe "Handles multiple databases" do
    it "copies each database" do
      
    end
    
    it "on a failure, will continue to backup others databases" do
      
    end
    
  end
  
  
  
  describe "Emails the results" do
    describe "success" do
      it "sends an email if the email_on_success config is set" do
        
      end
      it "does not send an email if no email_on_success set" do
        
      end
    end
    describe "failure" do
      it "sends an email" do
        
      end
      it "includes the cause" do
        
      end
    end
  end
end











