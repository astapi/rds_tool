@rds_instances = [
  {
    #:db_instance_id => 'majidev',
    #:db_instance_class => 'db.t1.micro',
    #:db_security_group_id => 'sg-237ac746',
    #:db_security_group_name => 'maji-db',
    #:db_parameter_group => 'default.oracle-se1-11.2',
    :db_instance_id => 'majibu',
    :db_instance_class => 'db.t1.micro',
    :db_subnet_group_name => 'default-vpc-c3ff2aa6',
    :vpc_security_group_ids => 'vpc-c3ff2aa6:majibu_vpc',
    :db_security_group_id => 'sg-75962c10',
    :db_security_group_name => 'rds-launch-wizard-2',
    :db_parameter_group => 'default.oracle-se1-11.2',
  }
]
