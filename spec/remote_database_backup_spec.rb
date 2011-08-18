require File.expand_path(File.dirname(__FILE__) + '/../lib/remote_database_backup.rb')
require 'yaml'

config = {'staging'=>'staging','destination'=>'target'}
dbs = YAML.load_file( 'test_databases.yaml' )
good_db = dbs['good_database']
other_db = dbs['other_good_database']
bad_db = dbs['bad_database']

all_good = [good_db, other_db]
all_good_and_bad = [other_db, bad_db, good_db]



Rdb = RemoteDatabaseBackup


describe 'RemoteDatabaseBackup' do
  
  describe "clear staging area" do
    before do
      `touch staging/a.sql`
      Rdb.clear_staging_area(config)
    end
    
    subject { Dir.glob("staging/{*,.*}") }
    it { should have(2).items }
  end

  describe "Downloads an entire database" do
    before(:all) do
      Rdb.download_database(good_db, config)
    end
    it "one file for each table" do
      Dir.glob("staging/good_database.sql").should have(1).items
    end
  end

  
  describe "rsnapshots a downloaded database" do
    describe "success" do
      it "rsnapshot copys to target area" do
        Rdb.backup_database(good_db, config)
      end
    end
    describe "failure" do
      it "notes failure" do
        expect { Rdb.backup_database(bad_db, config) }
      end
    end
    
  end
  
  
  describe "Handles multiple databases" do
    describe "success" do
      before(:all) do
        @successes, @results = Rdb.backup_all_databases(all_good, config)
      end
      it "shows as succeeded" do
        @successes.should be_true
      end
      it "copies each database" do
        
      end
    end

    describe "on a failure, will continue to backup other databases" do
      before(:all) do
        @successes, @results = Rdb.backup_all_databases(all_good, config)
      end
      it "fails with a bad database" do
        @successes.should be_false
      end 
    end
  end
  
  
  
  describe "Emails the results" do
    describe "success" do
      before(:all) do
        @email = Rdb.backup_all_databases_and_email(all_good, config)
      end
      it "sends an email" do
        
      end
    end
    describe "failure" do
      before(:all) do
        @email = Rdb.backup_all_databases_and_email(all_good_and_bad, config)
      end
      it "sends an email" do
        @email.match(/Fail/).should be_true
      end
    end
  end
end











