pragma solidity ^0.4.19;
contract SharedOffice {

    struct Office {
        address owner;
        string physicalAddress;
        uint areaInSqFt;
        uint rentalCost;
        address currentRenter;
    }

    mapping(address => Office) offices;

    function SharedOffice() public {
        // TODO
    }
    
    function addOffice(address owner, string physicalAddress, uint areaInSqFt, uint rentalCost) public {
        if (owner == address(0)) return;
        offices[owner] = Office(owner, physicalAddress, areaInSqFt, rentalCost, address(0));
    }

    function occupyOffice(address owner, address renter) public {
        if (owner == address(0)) return;
        if (renter == address(0)) return;
        if (offices[owner].currentRenter != address(0)) return;
        
        offices[owner].currentRenter = renter;
    }

    function chargeRenter(address owner, address renter) public {
        
    }
}