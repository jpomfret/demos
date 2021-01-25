# Blog examples for
# Discovery AD

Import-Module dbatools, ActiveDirectory

# setup - create some AD users\groups uing the ActiveDirectory module
    # create several new ad users
    ('pomfretJ','smithA', 'jonesP','barnesR').foreach{New-AdUser $_}

    # view newly created users
    $date = (get-date).AddHours(-1)
    get-aduser -filter {created -gt $date} | select name

    # create a new Ad group
    $newAdGroup = @{
        Name          = 'AdventureWorksReadOnly'
        GroupCategory = 'Security'
        GroupScope    = 'Global'
        Path          = 'CN=Users,DC=pomfret,DC=com'
    }
    New-ADGroup @newAdGroup

    # add users to group
    $addMemberGroup = @{
        Identity = 'AdventureWorksReadOnly'
        Members = 'pomfretj', 'jonesP'
    }
    Add-ADGroupMember @addMemberGroup

# setup - grant permissions to ad users\groups using dbatools

    # add ad group and grant permissions (db_datareader to AdventureWorks)
    New-DbaLogin -SqlInstance dscsvr1 -Login 'Pomfret\AdventureWorksReadOnly'
    New-DbaDbUser -SqlInstance dscsvr1 -Database AdventureWorks2017 -Login 'Pomfret\AdventureWorksReadOnly'
    Add-DbaDbRoleMember -SqlInstance dscsvr1 -Database AdventureWorks2017 -Role db_datareader -User 'Pomfret\AdventureWorksReadOnly' -Confirm:$false

    # add ad user to sql server and provide permissions (db_owner to AdventureWorks)
    New-DbaLogin -SqlInstance dscsvr1 -Login 'Pomfret\smithA'
    New-DbaDbUser -SqlInstance dscsvr1 -Database AdventureWorks2017 -Login 'Pomfret\smithA'
    Add-DbaDbRoleMember -SqlInstance dscsvr1 -Database AdventureWorks2017 -Role db_owner -User 'Pomfret\smithA' -Confirm:$false

# view database users that have access to database
    Get-DbaDbUser -SqlInstance dscsvr1 -Database AdventureWorks2017 -ExcludeSystemUser |
    Select-Object SqlInstance, Database, Login, LoginType, HasDbAccess

# view database users that are members of database roles
Get-DbaDbRoleMember -SqlInstance dscsvr1 -Database AdventureWorks2017 | Select-Object SqlInstance, Database, role, Login

# view database users that are members of server roles
    Get-DbaServerRoleMember -SqlInstance dscsvr1 | Select-Object SqlInstance, Name, Role

# view who has permissions via AD groups
    Get-DbaDbRoleMember -SqlInstance dscsvr1 -Database AdventureWorks2017 |
    Select-Object SqlInstance, Database, Role, LoginType, Login, @{l='GroupMembers';e={ (Get-AdGroupMember -Identity ($_.Login).Split('\')[1]).Name }}