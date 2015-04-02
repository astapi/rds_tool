require 'aws-sdk'
require 'yaml'
require 'pp'

AWS.config(YAML.load(File.read("./aws-config.yml")))

#rds = Aws::RDS::Client.new(YAML.load(File.read("./aws-config.yml")))
rds = AWS::RDS.new()
#response = rds.client.describe_db_instances()
p rds
#response = rds.client.describe_db_instances()
p "start"

ins_name = 'rdstest'

p "This rds id is ... " + ins_name
final_db_snapshot = "#{ins_name}-final-snapshot"

backup_snapshot = nil
response = rds.client.describe_db_snapshots({ :db_instance_identifier => ins_name })
response[:db_snapshots].each do |cur_snapshot|
  if cur_snapshot[:db_snapshot_identifier] == final_db_snapshot
    backup_snapshot = cur_snapshot
  end
end

if backup_snapshot != nil
  p "delete old snaphost ..."
  rds.client.delete_db_snapshot({:db_snapshot_identifier => backup_snapshot[:db_snapshot_identifier]})
  sleep(10)
end

p "make snahoshot : " + final_db_snapshot
rds.client.create_db_snapshot({ :db_instance_identifier => ins_name, :db_snapshot_identifier => final_db_snapshot })
status = "creating"
while status != "available" do
  sleep(20)
  p "check snapshot status ..."
  response2 = rds.client.describe_db_snapshots({:db_snapshot_identifier => final_db_snapshot})
  status = response2[:db_snapshots][0][:status]
  p "snapshot staus is : " + status
end

p "snapshot done"
p "delete instance ..."
rds.client.delete_db_instance({:db_instance_identifier => ins_name , :skip_final_snapshot => true})
p "now deleting"

p "end"
