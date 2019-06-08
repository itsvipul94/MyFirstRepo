$Akey= "AKIAJ4VI6W6DX6E34SKA"
$SKey= "gkB2ICgxYYwxKCqAtRl3CogLtDjcX49lMInfbzZc"
$Region="ap-southeast-1"
$LBname='wkdemo'

############### Checking Port and Protocol described in tags ##########################
$Keys=((Get-ELBTags -LoadBalancerName $LBname -Region $Region).Tags).Key
$Value=((Get-ELBTags -LoadBalancerName $LBname -Region $Region).Tags).Value
for($i=0;$i -lt (Get-ELBTags -LoadBalancerName $LBname -Region $Region).Tags.Count;$i++)
{
if($Keys[$i].indexOf("LBProtocol") -ge 0)
{
$LBProtocol=$Value[$i]
}
elseif($Keys[$i].indexOf("InstanceProtocol") -ge 0)
{
$InstanceProtocol=$Value[$i]
}
elseif($Keys[$i].indexOf("InstancePort") -ge 0)
{
$InstancePort=$Value[$i]
}
elseif($Keys[$i].indexOf("LBPort") -ge 0)
{
$LBPort=$Value[$i]
}
}

############### Checking existing listener port and protocol and correcting If needed ##############################3
$ExistingListener=(Get-ELBLoadBalancer -LoadBalancerName $LBname -Region $Region).ListenerDescriptions
if($ExistingListener.Count -EQ 0)
{
$Listener = New-Object Amazon.ElasticLoadBalancing.Model.Listener
$Listener.Protocol = $LBProtocol
$Listener.LoadBalancerPort = $LBPort
$Listener.InstancePort=$InstancePort
$Listener.InstanceProtocol=$InstanceProtocol
New-ELBLoadBalancerListener -Listener $Listener -LoadBalancerName $LBname -Region $Region
echo "Successfully configured the listener as per the port and protocol defined in the tags"
}

else{
$flaga=0;
$flagb=0;
$flagc=0;
$flagd=0;

$ConfiguredLBPort=(((Get-ELBLoadBalancer -LoadBalancerName $LBname -Region $Region).ListenerDescriptions).Listener).LoadBalancerPort
$ConfiguredLBProtocol=(((Get-ELBLoadBalancer -LoadBalancerName $LBname -Region $Region).ListenerDescriptions).Listener).Protocol
$ConfiguredInstancePort=(((Get-ELBLoadBalancer -LoadBalancerName $LBname -Region $Region).ListenerDescriptions).Listener).InstancePort
$ConfiguredInstanceProtocol=(((Get-ELBLoadBalancer -LoadBalancerName $LBname -Region $Region).ListenerDescriptions).Listener).InstanceProtocol

if($ConfiguredLBPort -EQ $LBPort)
{
$flaga=1;
write-host "Listener configured on correct port for Load balancer"
}
if($ConfiguredInstancePort -EQ $InstancePort)
{
$flagb=1;
write-host "Listener configured on correct port for the instances"
}
if($ConfiguredLBProtocol.indexOf($LBProtocol) -ge 0)
{
$flagc=1;
write-host "Listener configured on correct protocol for the LB"
}
if($ConfiguredInstanceProtocol.indexOf($InstanceProtocol) -ge 0)
{
$flagd=1;
write-host "Listener configured on correct protocol for the Instances"
}

if($flaga -EQ 0 -or $flagb -EQ 0 -or $flagc -EQ 0 -or $flagd -EQ 0)
{
Remove-ELBLoadBalancerListener -LoadBalancerName $LBname -Region $Region -Force -LoadBalancerPort $ConfiguredLBPort
$Listener = New-Object Amazon.ElasticLoadBalancing.Model.Listener
$Listener.Protocol = $LBProtocol
$Listener.LoadBalancerPort = $LBPort
$Listener.InstancePort=$InstancePort
$Listener.InstanceProtocol=$InstanceProtocol
New-ELBLoadBalancerListener -Listener $Listener -LoadBalancerName $LBname -Region $Region
Write-host "Successfully Corrected the listener port/protocol for LB/Instance"
}
if($flaga -and 1 -and $flagb -EQ 1 -and $flagc -EQ 1 -and $flagd -EQ 1)
{
Echo "All the listener configurations of the load balancer $LB are as per the one defined in the tags.Script executed Successfully"
} 

}

