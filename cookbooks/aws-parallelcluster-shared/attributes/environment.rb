default['cluster']['region'] = 'us-east-1'

# AWS domain
default['cluster']['aws_domain'] = aws_domain

# URL for ParallelCluster Artifacts stored in public S3 buckets
# ['cluster']['region'] will need to be defined by image_dna.json during AMI build.
default['cluster']['s3_url'] = "https://#{node['cluster']['region']}-aws-parallelcluster.s3.#{node['cluster']['region']}.#{node['cluster']['aws_domain']}"
default['cluster']['artifacts_s3_url'] = "#{node['cluster']['s3_url']}/archives"
