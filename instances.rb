@rds_instances = [
  {
    :db_instance_id => 'rdstest',
    :db_instance_class => 'db.t1.micro',
    :db_subnet_group_name => 'default-vpc-c705d3a2',
    :vpc_security_group_ids => 'sg-01e56564',
    :db_security_group_id => 'sg-75962c10',
    :db_security_group_name => 'rdssg',
    :db_parameter_group => 'default.oracle-se1-11.2',
    :publicly_accessible => true,
  }
]
