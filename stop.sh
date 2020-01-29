ec2=i-03c2e141ae905e7e7
aws ec2 stop-instances --instance-id $ec2
unset Dns
unset ec2
echo "\n\nstopping $ec2"
status=$(aws ec2 describe-instances --instance-id $ec2 --query 'Reservations[0].Instances[0].State.Name')
status=${status#"\""}
status=${status%"\""}
while
    [ "$status" != "stopped" ]
do
    status=$(aws ec2 describe-instances --instance-id $ec2 --query 'Reservations[0].Instances[0].State.Name')
    status=${status#"\""}
    status=${status%"\""}
    echo ". "
done
echo "stopped"