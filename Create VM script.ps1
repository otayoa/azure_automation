# Connecting to your Azure Subscription with your account
Connect-AzAccount

# creating resource group to house resources to be created and managed with the same policy
New-AzResourceGroup -Name DevResources -Location westeurope

# a credential object is a required parameter for VM, it contains
# both the username and password for the administrator account of the Microsoft VM
$cred = Get-Credential -Message "Enter username and password for the VM"

# the VM parameters and arguments required for the VM creation.
$vmParam = @{
                ResourceGroupName = 'DevResources'
                Name = 'DevVM1'
                Location = 'westeurope'
                ImageName = 'Win2016Datacenter'
                Credential = $cred
                OpenPorts = 3389
                PublicIpAddressName = 'tutorialPublicIp'
            }
$newVM1 = New-AzVM @vmParam

# verifying the status of the provisioned VM and querying the VM for information.
$newVM1

$newVM1.OSProfile | Select-Object ComputerName, AdminUserName

$newVM1 | Get-AzNetworkInterface | Select-Object -ExcludeProperty IpConfigurations | 
    Select-Object Name, PrivateIpAddress



$vm2Param = @{
ResourceGroupName = 'DevResources'
Name = 'DevVM2'
ImageName = 'Win2016Datacenter'
VirtualNetworkName = 'DevVM1'
SubnetName = 'DevVM1'
PublicIpAddressName = 'tutorialPublicIp2'
Credential = $cred
OpenPorts = 3389
}

$newVM2 = New-AzVM @vm2Param

$newVM2

# connecting to your VM via RDP using public Ip or FQDN of the VM
$publicIp = Get-AzPublicIpAddress -Name tutorialPublicIp -ResourceGroupName Devresources
mstsc.exe /v $publicIp.IpAddress
mstsc.exe /v $newVM2.FullyQualifiedDomainName

$job = Remove-AzResourceGroup -Name Devresources -Force -AsJob

$job
