require "aws-sdk"
rds = AWS::RDS.new(
  :access_key_id => <ACCESS_KEY_ID>,
  :secret_access_key => <SECRET_ACCESS_KEY>,
  :rds_endpoint => <RDS_ENDPOINT_URL>
)
 
rds.db_instances.each {|instance|
  p instance.endpoint_address
}
