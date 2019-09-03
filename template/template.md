# 1Hive Template

## Usage

Create new tokens and initialize DAO for a 1Hive project:

```
template.prepareInstance(mbrTokenName, mrtTokenName, mbrTokenSymbol, mrtTokenSymbol)
```

- `mbrTokenName`: Name for the token used by Members in the organization
- `mbrTokenSymbol`: Symbol for the token used by Members in the organization
- `mrtTokenName`: Name for the token used to reward Merit in the organization
- `mrtTokenSymbol`: Symbol for the token used to reward Merit in the organization

Setup 1Hive DAO:

```
template.setupInstance(name, memberHolders, memberVoteSettings, meritVoteSettings, dotVoteQuorum)
```

- `name`: Name for org, will assign `[name].aragonid.eth`
- `memberHolders`: Array of member addresses (1 token will be minted for each member)
- `memberVoteSettings`: Array of [supportRequired, minAcceptanceQuorum, voteDuration] for votes by the organization's members
- `meritVoteSettings`: Array of [supportRequired, minAcceptanceQuorum, voteDuration] for votes by the organization's merit holders
- `dotVoteQuorum`:  the quorum required for the dot voting app

## Deploying templates

After deploying ENS, APM and AragonID, just run:

```
npm run deploy:rinkeby
```

The network details will be automatically selected by the `arapp.json`'s environments.


| Application   | Permission                 | Grantee       | Manager|
|:--------------|:-------------------------- |:------------- |:-------|
| Kernal | APP_MANAGER | Bee voting | Bee voting |
| ACL | CREATE_PERMISSIONS | Bee voting | Bee voting |
| EVMScriptRegistry | REGISTRY_MANAGER | Bee voting | Bee voting |
| EVMScriptRegistry | REGISTRY_ADD_EXECUTOR | Bee voting | Bee voting |
| Bee manager | MINT_ROLE | Bee voting | Bee voting |
| Bee manager | ISSUE_ROLE | Bee voting | Bee voting |
| Bee manager | ASSIGN_ROLE | Bee voting | Bee voting |
| Bee manager | BURN_ROLE | Bee voting | Bee voting |
| Honey manager | MINT_ROLE | Honey voting | Bee voting |
| Honey manager | ISSUE_ROLE | Honey voting | Bee voting |
| Honey manager | ASSIGN_ROLE | Honey voting | Bee voting |
| Honey manager | BURN_ROLE | Honey voting | Bee voting |
| Vault | BURN_ROLE | Honey voting | Bee voting |
| Finance | CREATE_PAYMENTS_ROLE | Honey voting | Bee voting |
| Finance | MANAGE_PAYMENTS_ROLE | Honey voting | Bee voting |
| Finance | CREATE_VOTES_ROLE | bee voting | Bee voting |
| Honey voting | CREATE_VOTES_ROLE | honey voting | Bee voting |
| Bee voting   | CREATE_VOTES_ROLE | bee voting   | Bee voting |
| Vault allocations | TRANSFER_ROLE | projects | Bee voting |
| Vault allocations | TRANSFER_ROLE | Allocations | Bee voting |
| Address book | ADD_ENTRY_ROLE | Bee voting | Bee voting |
| Address book | REMOVE_ENTRY_ROLE | Bee voting | Bee voting |
| Projects  | CHANGE_SETTINGS_ROLE | Bee voting | Bee voting |
| Projects  | ADD_REPO_ROLE  | Bee voting | Bee voting |
| Projects  | REMOVE_REPO_ROLE   | Bee voting | Bee voting |
| Projects  | CURATE_ISSUES_ROLE   | Dot voting  | Bee voting |
| Dot voting   | CREATE_VOTES_ROLE   | Bee manager  | Bee voting |
| Dot voting   | ADD_CANDIDATES_ROLE   | Bee manager  | Bee voting |
| Allocations    | CREATE_ACCOUNT_ROLE   | Bee manager  | Bee voting |
| Allocations    | CREATE_ALLOCATION_ROLE   | Bee manager  | Bee voting |
| Allocations    | EXECUTE_ALLOCATION_ROLE   | Bee manager  | Bee voting |
