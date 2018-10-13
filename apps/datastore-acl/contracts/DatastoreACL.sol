pragma solidity ^0.4.24;

import "@aragon/os/contracts/apps/AragonApp.sol";


contract DatastoreACL is AragonApp {

    function initialize() onlyInit public {
        initialized();
    }

    function test() public returns (uint) {
        return 99;
    }

}