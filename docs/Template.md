# 1Hive Template
What is the 1Hive template......
## Usage Deploying template Permissions
| Application | Permission | Grantee | Manager|
|:----------- |:---------- |:------- |:-------|
| Kernal | APP_MANAGER | Bee voting | Bee voting |
 ACL | 
| CREATE_PERMISSIONS | Bee voting | Bee voting | EVMScriptRegistry 
| | REGISTRY_MANAGER | Bee voting | Bee voting |
| EVMScriptRegistry | REGISTRY_ADD_EXECUTOR | Bee voting | Bee 
| voting | Bee manager | MINT_ROLE | Bee voting | Bee voting | Bee 
| manager | ISSUE_ROLE | Bee voting | Bee voting | Bee manager | 
| ASSIGN_ROLE | Bee voting | Bee voting | Bee manager | BURN_ROLE 
| | Bee voting | Bee voting |
| Honey manager | MINT_ROLE | Honey voting | Bee voting | Honey 
| manager | ISSUE_ROLE | Honey voting | Bee voting | Honey manager 
| | ASSIGN_ROLE | Honey voting | Bee voting |
| Honey manager | BURN_ROLE | Honey voting | Bee voting | Vault | 
| BURN_ROLE | Honey voting | Bee voting | Finance | 
| CREATE_PAYMENTS_ROLE | Honey voting | Bee voting | Finance | 
| MANAGE_PAYMENTS_ROLE | Honey voting | Bee voting | Finance | 
| CREATE_VOTES_ROLE | bee voting | Bee voting | Honey voting | 
| CREATE_VOTES_ROLE | honey voting | Bee voting | Vault 
| allocations | TRANSFER_ROLE | projects | Bee voting | Vault 
| allocations | TRANSFER_ROLE | Allocations | Bee voting | Address 
| book | ADD_ENTRY_ROLE | Bee voting | Bee voting | Address book | 
| REMOVE_ENTRY_ROLE | Bee voting | Bee voting | Projects | 
| CHANGE_SETTINGS_ROLE | Bee voting | Bee voting | Projects | 
| ADD_REPO_ROLE | Bee voting | Bee voting | Projects | 
| REMOVE_REPO_ROLE | Bee voting | Bee voting | Projects | 
| CURATE_ISSUES_ROLE | Dot voting | Bee voting | Dot voting  | 
| CREATE_VOTES_ROLE | Bee manager | Bee voting | Dot voting  | 
| ADD_CANDIDATES_ROLE | Bee manager | Bee voting | Allocations   | 
| CREATE_ACCOUNT_ROLE | Bee manager | Bee voting | Allocations   | 
| CREATE_ALLOCATION_ROLE | Bee manager | Bee voting |
| Allocations    | EXECUTE_ALLOCATION_ROLE   | Bee manager  | Bee voting |
