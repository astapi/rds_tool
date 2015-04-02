require 'aws-sdk'
require './instances.rb'

WAIT_TIME = 60

AWS.config(YAML.load(File.read("./aws-config.yml")))
rds = AWS::RDS.new
response = rds.client.describe_db_instances

@rds_instances.each do |ins|
  exist_ins = false
  response[:db_instances].each do |cur_instance|
    if cur_instance[:db_instance_identifier] == ins[:db_instance_id]
      p "RDS(" + ins[:db_instance_id] + ") status is " + cur_instance[:db_instance_status]
      p cur_instance[:db_security_groups]
      exist_ins = true
    end
  end

  exit if exist_ins
  response2 = rds.client.describe_db_snapshots({:db_instance_identifier=>ins[:db_instance_id]})  	
  snapshots = response2[:db_snapshots].sort{|x,y| y[:snapshot_create_time] <=> x[:snapshot_create_time]}
  p "restore from db snapshot from " + snapshots[0][:db_snapshot_identifier]
  rds.client.restore_db_instance_from_db_snapshot(
    {
      :db_instance_identifier => ins[:db_instance_id],
      :db_snapshot_identifier=>snapshots[0][:db_snapshot_identifier],
      :db_subnet_group_name=>ins[:db_subnet_group_name],
      :db_instance_class=>ins[:db_instance_class],
      :availability_zone=>"ap-northeast-1a",
      :multi_az=>false,
  #    :db_name=>"ORCL",
    }
  )

  status = "creating"
  while status != "available" do
    sleep(WAIT_TIME)
    p "check rds status "
    response2 = rds.client.describe_db_instances({:db_instance_identifier=>ins[:db_instance_id]})
    status = response2[:db_instances][0][:db_instance_status]
    p "rds staus is :" + status
  end
  p "done"

  p "modify parameter settings ..."
  rds.client.modify_db_instance(
    {
      :db_instance_identifier => ins[:db_instance_id],
      :db_security_groups => [ins[:db_security_group_id]],
      :db_parameter_group_name => ins[:db_parameter_group],
    }
  )

  status = "modify"
  while status != "available" do
    sleep(WAIT_TIME)
    p "check rds status "
    response2 = rds.client.describe_db_instances({:db_instance_identifier=>ins[:db_instance_id]})
    status = response2[:db_instances][0][:db_instance_status]
    p "rds staus is :" + status
  end
  p "done"


  p "reboot to use new settings ..."
  rds.client.reboot_db_instance({:db_instance_identifier=>ins[:db_instance_id]})
  status = "rebooting..."
  while status != "available" do
    sleep(WAIT_TIME)
    p "check rds status "
    response2 = rds.client.describe_db_instances({:db_instance_identifier=>ins[:db_instance_id]})
    status = response2[:db_instances][0][:db_instance_status]
    p "rds staus is :" + status
  end
  p "rds (" + ins[:db_instance_id] + ") started!"
end
