@description('Location for all resources.')
param location string = resourceGroup().location

@description('Name for SQL Server')
param serverName string = uniqueString('sql',resourceGroup().id)

@description('Name for Azure SQL Database')
param databaseName string = 'MySampleDB'

@description('Name for SQL admin user')
param adminName string = 'sqlAdmin'


// SQL Server need to be created before the database
resource sqlServer 'Microsoft.Sql/servers@2021-05-01-preview' = {
  name: serverName
  location: location
  properties:{
    administratorLogin: adminName
    administratorLoginPassword: 'H3c3du!00/&'
  }
}

// Database creation
resource sqlDatabase 'Microsoft.Sql/servers/databases@2022-08-01-preview'={
  parent:sqlServer // Explicit dependency from SQL server created previously
  name: databaseName
  location: location
  sku:{
    capacity: 1 
    family: 'Gen5'
    name: 'GP_S_Gen5_1'
    tier: 'GeneralPurpose'
  }
  properties:{
    zoneRedundant: false
    autoPauseDelay: 60
    minCapacity: 1
    isLedgerOn: false
    sampleName: 'AdventureWorksLT'
  }
}
