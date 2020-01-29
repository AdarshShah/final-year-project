ec2=i-03c2e141ae905e7e7
aws ec2 describe-instance-status --instance-ids $ec2

Dns=$(aws ec2 describe-instances --instance-ids $ec2 --query 'Reservations[0].Instances[0].PublicDnsName')
Dns=${Dns#"\""}
Dns=${Dns%"\""}
if [ -z "$Dns" ]
then
    echo "$ec2 State: stopped"
    exit 1
fi

end=$(date --iso-8601=seconds) 
start=$(date --iso-8601=seconds --date=@$(($(date +%s)-60)))
echo "Metrics\t\tAverage\t\tMaximum"

metric="CPUUtilization"
Avg=$(aws cloudwatch get-metric-statistics --metric-name $metric --start-time $start --end-time $end --period 60 --namespace AWS/EC2 --statistics Average --unit Percent --dimensions Name=InstanceId,Value=$ec2 --query "Datapoints[0].Average")
Max=$(aws cloudwatch get-metric-statistics --metric-name $metric --start-time $start --end-time $end --period 60 --namespace AWS/EC2 --statistics Maximum --unit Percent --dimensions Name=InstanceId,Value=$ec2 --query "Datapoints[0].Maximum")
echo "$metric\t$Avg\t$Max"

metric="DiskReadOps"
Avg=$(aws cloudwatch get-metric-statistics --metric-name $metric --start-time $start --end-time $end --period 60 --namespace AWS/EC2 --statistics Average --unit Count --dimensions Name=InstanceId,Value=$ec2 --query "Datapoints[0].Average")
Max=$(aws cloudwatch get-metric-statistics --metric-name $metric --start-time $start --end-time $end --period 60 --namespace AWS/EC2 --statistics Maximum --unit Count --dimensions Name=InstanceId,Value=$ec2 --query "Datapoints[0].Maximum")
echo "$metric\t$Avg\t$Max"

metric="DiskWriteOps"
Avg=$(aws cloudwatch get-metric-statistics --metric-name $metric --start-time $start --end-time $end --period 60 --namespace AWS/EC2 --statistics Average --unit Count --dimensions Name=InstanceId,Value=$ec2 --query "Datapoints[0].Average")
Max=$(aws cloudwatch get-metric-statistics --metric-name $metric --start-time $start --end-time $end --period 60 --namespace AWS/EC2 --statistics Maximum --unit Count --dimensions Name=InstanceId,Value=$ec2 --query "Datapoints[0].Maximum")
echo "$metric\t$Avg\t$Max"

metric="DiskReadBytes"
Avg=$(aws cloudwatch get-metric-statistics --metric-name $metric --start-time $start --end-time $end --period 60 --namespace AWS/EC2 --statistics Average --unit Bytes --dimensions Name=InstanceId,Value=$ec2 --query "Datapoints[0].Average")
Max=$(aws cloudwatch get-metric-statistics --metric-name $metric --start-time $start --end-time $end --period 60 --namespace AWS/EC2 --statistics Maximum --unit Bytes --dimensions Name=InstanceId,Value=$ec2 --query "Datapoints[0].Maximum")
echo "$metric\t$Avg\t$Max"

metric="DiskWriteBytes"
Avg=$(aws cloudwatch get-metric-statistics --metric-name $metric --start-time $start --end-time $end --period 60 --namespace AWS/EC2 --statistics Average --unit Bytes --dimensions Name=InstanceId,Value=$ec2 --query "Datapoints[0].Average")
Max=$(aws cloudwatch get-metric-statistics --metric-name $metric --start-time $start --end-time $end --period 60 --namespace AWS/EC2 --statistics Maximum --unit Bytes --dimensions Name=InstanceId,Value=$ec2 --query "Datapoints[0].Maximum")
echo "$metric\t$Avg\t$Max"