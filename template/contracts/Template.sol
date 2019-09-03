pragma solidity ^0.4.24;

import "@aragon/os/contracts/factory/DAOFactory.sol";
import "@aragon/os/contracts/apm/Repo.sol";
import "@aragon/os/contracts/lib/ens/ENS.sol";
import "@aragon/os/contracts/lib/ens/PublicResolver.sol";
import "@aragon/os/contracts/apm/APMNamehash.sol";

import "@aragon/apps-voting/contracts/Voting.sol";
import "@aragon/apps-token-manager/contracts/TokenManager.sol";
import "@aragon/apps-shared-minime/contracts/MiniMeToken.sol";
import "@aragon/apps-vault/contracts/Vault.sol";
import "@aragon/apps-finance/contracts/Finance.sol";


contract TemplateBase is APMNamehash {
    ENS public ens;
    DAOFactory public fac;

    event DeployInstance(address dao);
    event InstalledApp(address appProxy, bytes32 appId);

    constructor(DAOFactory _fac, ENS _ens) public {
        ens = _ens;

        // If no factory is passed, get it from on-chain bare-kit
        if (address(_fac) == address(0)) {
            bytes32 bareKit = apmNamehash("bare-kit");
            fac = TemplateBase(latestVersionAppBase(bareKit)).fac();
        } else {
            fac = _fac;
        }
    }

    function latestVersionAppBase(bytes32 appId) public view returns (address base) {
        Repo repo = Repo(PublicResolver(ens.resolver(appId)).addr(appId));
        (,base,) = repo.getLatest();

        return base;
    }
}

contract Template is TemplateBase {
    string constant private ERROR_MISSING_CACHE = "COMPANYBD_MISSING_CACHE";

    bytes32 constant internal VAULT_APP_ID = 0x7e852e0fcfce6551c13800f1e7476f982525c2b5277ba14b24339c68416336d1;
    bytes32 constant internal VOTING_APP_ID = 0x9fa3927f639745e587912d4b0fea7ef9013bf93fb907d29faeab57417ba6e1d4;
    bytes32 constant internal FINANCE_APP_ID = 0xbf8491150dafc5dcaee5b861414dca922de09ccffa344964ae167212e8c673ae;
    bytes32 constant internal TOKEN_MANAGER_APP_ID = 0x6b20a3010614eeebf2138ccec99f028a61c811b3b1a3343b6ff635985c75c91f;

    uint64 constant PCT = 10 ** 16;
    uint32 constant DEFAULT_PERIOD = 2419200;
    address constant ANY_ENTITY = address(-1);

    struct Cache {
        address dao;
        address meritToken;
        address memberToken;
        address meritVoting;
        address memberVoting;
    }

    mapping (address => Cache) internal cache;

    MiniMeTokenFactory tokenFactory;

    constructor(ENS ens) TemplateBase(DAOFactory(0), ens) public {
        tokenFactory = new MiniMeTokenFactory();
    }

    function newInstance() public {
        prepareDAO();
        setupA1Apps();

        emit DeployInstance(Kernel(cache[msg.sender].dao));
        _clearCache();
        _cleanPermissions();
    }

    function prepareDAO() public {
        // Create DAO and assign template permissions in the DAO
        Kernel dao = fac.newDAO(this);
        ACL acl = ACL(dao.acl());
        acl.createPermission(this, dao, dao.APP_MANAGER_ROLE(), this);

        // create tokens
        MiniMeToken memberToken = tokenFactory.createCloneToken(MiniMeToken(0), 0, "BEE Token", 0, "BEE", true);
        MiniMeToken meritToken = tokenFactory.createCloneToken(MiniMeToken(0), 0, "Honey Token", 0, "HONEY", true);

        // Create voting
        Voting memberVoting = Voting(dao.newAppInstance(VOTING_APP_ID, latestVersionAppBase(VOTING_APP_ID)));
        Voting meritVoting = Voting(dao.newAppInstance(VOTING_APP_ID, latestVersionAppBase(VOTING_APP_ID)));


        // initialize voting & token manager apps 
        memberVoting.initialize(memberToken, 50 * PCT, 20 * PCT, 1 days); //<-- will remove hard coding
        meritVoting.initialize(meritToken, 50 * PCT, 20 * PCT, 1 days); //<-- will remove hard coding

        // Cache DAO, tokens and voting apps
        Cache storage c = cache[msg.sender];
        c.dao = dao;
        c.meritToken = meritToken;
        c.memberToken = memberToken;
        c.meritVoting = meritVoting;
        c.memberVoting = memberVoting;
    }

    function setupA1Apps() public {
        (MiniMeToken meritToken, MiniMeToken memberToken) = _tokenCaches();
        (Kernel dao, Voting meritVoting, Voting memberVoting) = _daoCache();
        ACL acl = ACL(dao.acl());

        // create apps
        TokenManager memberTokenManager = TokenManager(
            Kernel(dao).newAppInstance(
                TOKEN_MANAGER_APP_ID, 
                latestVersionAppBase(TOKEN_MANAGER_APP_ID)
            )
        );
        TokenManager meritTokenManager = TokenManager(
            Kernel(dao).newAppInstance(
                TOKEN_MANAGER_APP_ID, 
                latestVersionAppBase(TOKEN_MANAGER_APP_ID)
            )
        );
        Vault vault = Vault(
            dao.newAppInstance(
                VAULT_APP_ID, latestVersionAppBase(VAULT_APP_ID), 
                new bytes(0), 
                true
            )
        );
        Finance finance = Finance(
            dao.newAppInstance(
                FINANCE_APP_ID, 
                latestVersionAppBase(FINANCE_APP_ID)
            )
        );

        // initialize apps
        vault.initialize();
        finance.initialize(vault, DEFAULT_PERIOD); //<-- will remove hard coding
        memberTokenManager.initialize(MiniMeToken(memberToken), true, 0);
        meritTokenManager.initialize(MiniMeToken(meritToken), true, 0);

        // change token controler
        MiniMeToken(meritToken).changeController(meritTokenManager);
        MiniMeToken(memberToken).changeController(memberTokenManager); 
        
        //----------------------------- permissions move to seperate function -------------------------------\\

        // token managers permissions
        acl.createPermission(this, memberTokenManager, memberTokenManager.MINT_ROLE(), this);
        memberTokenManager.mint(msg.sender, 1); // Give one token to root
        acl.createPermission(this, meritTokenManager, meritTokenManager.MINT_ROLE(), this);
        meritTokenManager.mint(msg.sender, 1000000000000000000); // Give one token to root       

        // member token permissions
        acl.createPermission(memberVoting, memberTokenManager, memberTokenManager.ISSUE_ROLE(), memberVoting);
        acl.createPermission(memberVoting, memberTokenManager, memberTokenManager.ASSIGN_ROLE(), memberVoting);
        acl.createPermission(memberVoting, memberTokenManager, memberTokenManager.BURN_ROLE(), memberVoting);
        acl.grantPermission(memberVoting, memberTokenManager, memberTokenManager.MINT_ROLE());

        // merit token permissions
        acl.createPermission(meritVoting, meritTokenManager, meritTokenManager.ISSUE_ROLE(), meritVoting);
        acl.createPermission(meritVoting, meritTokenManager, meritTokenManager.ASSIGN_ROLE(), meritVoting);
        acl.createPermission(meritVoting, meritTokenManager, meritTokenManager.BURN_ROLE(), meritVoting);
        acl.grantPermission(meritVoting, meritTokenManager, meritTokenManager.MINT_ROLE());

        // voting permissions
        acl.createPermission(memberVoting, memberVoting, memberVoting.CREATE_VOTES_ROLE(), memberVoting);
        acl.createPermission(memberVoting, meritVoting, meritVoting.CREATE_VOTES_ROLE(), memberVoting);

        // vault permissions
        acl.createPermission(meritVoting, vault, vault.TRANSFER_ROLE(), memberVoting);

        // finance permissions
        acl.createPermission(meritVoting, finance, finance.CREATE_PAYMENTS_ROLE(), memberVoting);
        acl.createPermission(meritVoting, finance, finance.MANAGE_PAYMENTS_ROLE(), memberVoting);
    }

/*
    function installAutarkApps() internal {
        createDotVoting();
    }


    function createDotVoting (
        Kernel dao,
        MiniMeToken token,
        uint256 candidateSupportPct,
        uint256 minParticipationPct,
        uint64 voteDuration
    ) internal returns (AddressBook addressBook, DotVoting dotVoting)
    {
        addressBook = AddressBook(
            dao.newAppInstance(
                planningAppIds[uint8(PlanningApps.AddressBook)],
                latestVersionAppBase(planningAppIds[uint8(PlanningApps.AddressBook)])
            )
        );
        dotVoting = DotVoting(
            dao.newAppInstance(
                planningAppIds[uint8(PlanningApps.DotVoting)],
                latestVersionAppBase(planningAppIds[uint8(PlanningApps.DotVoting)])
            )
        );

        addressBook.initialize();
        dotVoting.initialize(addressBook, token, minParticipationPct, candidateSupportPct, voteDuration);
    }
*/

    //---------------- internal functions ---------------- //

    function _cleanPermissions() internal {
        (Kernel dao, Voting meritVoting, Voting memberVoting) = _daoCache();
        ACL acl = ACL(dao.acl());

        acl.grantPermission(memberVoting, dao, dao.APP_MANAGER_ROLE());
        acl.revokePermission(this, dao, dao.APP_MANAGER_ROLE());
        acl.setPermissionManager(memberVoting, dao, dao.APP_MANAGER_ROLE());

        acl.grantPermission(memberVoting, acl, acl.CREATE_PERMISSIONS_ROLE());
        acl.revokePermission(this, acl, acl.CREATE_PERMISSIONS_ROLE());
        acl.setPermissionManager(memberVoting, acl, acl.CREATE_PERMISSIONS_ROLE());
    }
    

    function _tokenCaches() internal returns (MiniMeToken meritToken, MiniMeToken memberToken) {
        Cache storage c = cache[msg.sender];
        require(c.meritToken != address(0) && c.memberToken != address(0), ERROR_MISSING_CACHE);

        meritToken = MiniMeToken(c.meritToken);
        memberToken = MiniMeToken(c.memberToken);
    }

    function _daoCache() internal returns (Kernel dao, Voting meritVoting, Voting memberVoting) {
        Cache storage c = cache[msg.sender];
        require(c.dao != address(0) && c.meritVoting != address(0) && c.memberVoting != address(0), ERROR_MISSING_CACHE);

        dao = Kernel(c.dao);
        meritVoting = Voting(c.meritVoting);
        memberVoting = Voting(c.memberVoting);
    }

    function _clearCache() internal {
        Cache storage c = cache[msg.sender];
        delete c.dao;
        delete c.meritVoting;
        delete c.memberVoting;
        delete c.meritToken;
        delete c.memberToken;
    }

}