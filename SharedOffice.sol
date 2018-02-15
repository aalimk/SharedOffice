pragma solidity ^0.4.19;

/** @title Smart contract to handle renting of unused office space. */
contract SharedOffice {
    
    // Struct to store Office data
    struct Office {
        address owner;
        string physicalAddress;
        uint areaInSqFt;
        uint rentalCost;
        address currentRenter;
    }

    // Object mapping owners to their office
    mapping(address => Office) offices;
    
     /** @dev Adds a new owner and office to the system.
      * @param owner Owner of the office.
      * @param physicalAddress Physical address of the office.
      * @param areaInSqFt Area of the office.
      * @param rentalCost Cost of renting the office.
      * @return Flag to denote if call completed successfully.
      */
    function addOffice(address owner, string physicalAddress, uint areaInSqFt, uint rentalCost) public returns (bool){
        require(owner != address(0));
        
        offices[owner] = Office(owner, physicalAddress, areaInSqFt, rentalCost, address(0));
        return true;
    }
    
     /** @dev Removes the owner and office from the system.
      * @param owner Owner of the office.
      * @return Flag to denote if call completed successfully.
      */
    function removeOffice(address owner) public returns (bool){
        require(owner != address(0));
        
        delete offices[owner];
        return true;
    }

    /** @dev Assigns a renter to the office owned by the given owner.
     * @param owner Owner of the office.
     * @param renter The entity renting the office.
     * @return Flag to denote if call completed successfully.
     */
    function assignRenter(address owner, address renter) public returns (bool) {
        require(owner != address(0));
        require(renter != address(0));
        require(offices[owner].currentRenter == address(0)); // Office must currently be unoccupied.
        
        offices[owner].currentRenter = renter;
        return true;
    }
    
    /** @dev Unassigns a renter from the office owned by the given owner.
     * @param owner Owner of the office.
     * @param renter The entity being unassigned from the office.
     * @return Flag to denote if call completed successfully.
     */
    function unassignRenter(address owner, address renter) public returns (bool) {
        require(owner != address(0));
        require(renter != address(0));
        require(offices[owner].currentRenter != address(0)); // Office must currently be occupied.
        
        offices[owner].currentRenter = address(0);
        return true;
    }

    /** @dev Pay rent to the owner.
     * @param owner Owner of the office.
     * @param renter The renter of the office.
     * @return Flag to denote if call completed successfully.
     */
    function payRent(address owner, address renter) public returns (bool) {
        require(owner != address(0));
        require(renter != address(0));
        // TODO - Add other checks like does the renter even rent from the given owner?
        
        owner.transfer(msg.value); // TODO - Unsure if this is the correct way to do this.
                                    // Probably won't need the renter address to be passed in.
        return true;
    }
}