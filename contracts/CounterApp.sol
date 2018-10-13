pragma solidity ^0.4.24;

import "@aragon/os/contracts/apps/AragonApp.sol";
import "@aragon/os/contracts/lib/math/SafeMath.sol";
import "@aragon/os/contracts/kernel/KernelConstants.sol";
import "@aragon/os/contracts/apm/APMNamehash.sol";
import "../apps/datastore-acl/contracts/DatastoreACL.sol";

contract CounterApp is AragonApp, APMNamehash {
    using SafeMath for uint256;

    /// Events
    event Increment(address indexed entity, uint256 step);
    event Decrement(address indexed entity, uint256 step);

    /// State
    uint256 public value;

    DatastoreACL private datastoreACL;

    /// ACL
    bytes32 constant public INCREMENT_ROLE = keccak256("INCREMENT_ROLE");
    bytes32 constant public DECREMENT_ROLE = keccak256("DECREMENT_ROLE");

    function initialize(address _datastoreACL) onlyInit public {
        initialized();

        datastoreACL = DatastoreACL(_datastoreACL);
    }

    function initialize() onlyInit public {
        initialized();

        address dAdd = kernel().getApp(KernelConstants.APP_BASES_NAMESPACE, apmNamehash("datastore-acl"));
        require(dAdd != 0, "DatastoreACL address invalid");
        datastoreACL = DatastoreACL(dAdd);
    }    

    /**
     * @notice Increment the counter by `step`
     * @param step Amount to increment by
     */
    function increment(uint256 step) auth(INCREMENT_ROLE) external {
        uint t = datastoreACL.test();
        value = value.add(t);
        emit Increment(msg.sender, t);
    }

    /**
     * @notice Decrement the counter by `step`
     * @param step Amount to decrement by
     */
    function decrement(uint256 step) auth(DECREMENT_ROLE) external {
        value = value.sub(step);
        emit Decrement(msg.sender, step);
    }
}
