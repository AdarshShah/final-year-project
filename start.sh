unset ec2
unset Dns
ec2=i-03c2e141ae905e7e7
echo "ec2 is $ec2"
aws ec2 start-instances --instance-id $ec2
Dns=$(aws ec2 describe-instances --instance-id $ec2 --query 'Reservations[0].Instances[0].PublicDnsName')
Dns=${Dns2#"\""}
Dns=${Dns%"\""}
echo "\n \nConnecting"
while 
    [ -z "$Dns" ]  
do
    Dns=$(aws ec2 describe-instances --instance-id $ec2 --query 'Reservations[0].Instances[0].PublicDnsName')
    Dns=${Dns#"\""}
    Dns=${Dns%"\""}
    echo "."
done
echo "Dns is $Dns"
sleep 5
ssh -i credentials/project-sepsis.pem ubuntu@$Dns