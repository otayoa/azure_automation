$group = "otdev"
$location = "westeurope"

# Creating a stroage account within a defined resource group
$storage = New-AzStorageAccount -ResourceGroupName $group -Name otdev -Location $location -SkuName Standard_LRS -Kind StorageV2

# Creating a blob Storage Container with the created Storage Account
$accountkey = (Get-AzStorageAccountKey -ResourceGroupName $group -Name $storage.StorageAccountName).Value[0]
$context = New-AzStorageContext -StorageAccountName $storage.StorageAccountName -StorageAccountKey $accountkey
New-AzStorageContainer -Name testblob -Context $context

# Create a new shared access policy for the newly created storage account
# create a policy with full access to the storage container base on the storage account context
New-AzStorageContainerStoredAccessPolicy -Context $context -Container testblob -Policy "FullAccessPolicy" -Permission "rwdl"

