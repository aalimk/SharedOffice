/* Authors:
Aalim Khan
Tara Amiri
*/
pragma solidity ^0.4.19;

//main weekness with this is that a physical address is the key, and so it can easily be misspelled
//currently it is missing an availability schedule (owner just rejects if the place is booked)
//@dev One office location can only have one owner (that's the account that gets paid after rental)



/* @title Smart contract to handle renting of unused office space. */
contract officeRental {
    
    //Struct to store office data
    struct office {
        address owner;
        string physicalAddress;
        uint areaInSqFt;
        uint dailyCost;
        bool isFurnished;
        bool isAvailable;
        rental[] bookings; //comment
        bool exists; //input comment

    }
    
    //Struct to store renta data
    struct rental {
        address renter;
        string physicalAddress;
        uint startDate;
        uint numDays;
        bool exists;
    }
    
    //Mapping of offices to their owners
    mapping (string => office) allOffices;
    
    /** 
     * @dev Allows an office owner to add their office and related information into the system.
     * @param physicalAddress The unique location (physical address) of the office.
     * @param areaInSqFt Size of the office in square feet.
     * @param dailyCost The daily cost (in wei) of renting the office.
     * @param isFurnished Flag to denote if the office is furnished.
     * @return Flag to denote if the office was added successfully.
     */
      
      
    //check for if someone else tries to add the same physicalAddress
    /*
    function addOffice(string physicalAddress, uint areaInSqFt, uint dailyCost, bool isFurnished) public returns (bool) {
        //make sure the office does not already exist in the system
        require(allOffices[physicalAddress].exists == false);  //check to make sure this is the right check
        
        allOffices[physicalAddress] = office(msg.sender, physicalAddress, areaInSqFt, dailyCost, isFurnished, true, bookings.push(adress(0), "", 0, 0, false), true);//empty rental
        return true;                                
    }*/
    
    /** 
     * @dev Allows an office owner to remove their office and related information from the system.
     * @dev Only the office owner can remove their office.
     * @param physicalAddress The unique location (physical address) of the office.
     * @return Flag to denote if the office was added successfully.
     */
    function removeOffice(string physicalAddress) public returns (bool) {
        require(allOffices[physicalAddress].owner == msg.sender);
        delete allOffices[physicalAddress]; //thought delete was only for arrays?
        return true;
    }

    /** 
     * @dev Allows an office owner to change the daily rent price of their office.
     * @dev Only the office owner can change the rent price.
     * @param physicalAddress The unique location (physical address) of the office.
     * @return Flag to denote if the price was changed successfully.
     */
    function changePrice(string physicalAddress, uint dailyCost) public returns (bool) {
        require(allOffices[physicalAddress].owner == msg.sender);
        allOffices[physicalAddress].dailyCost = dailyCost;
        return true;
    }
    
    /** 
     * @dev Allows an office owner to change the furniture flag of their office.
     * @dev Only the office owner can change the furniture flag. //change wording//
     * @param physicalAddress The unique location (physical address) of the office.
     * @return Flag to denote if the change was executed successfully.
     */
    function changeIsFurnished(string physicalAddress, bool isFurnished) public returns (bool) {
        require(allOffices[physicalAddress].owner == msg.sender);
        allOffices[physicalAddress].isFurnished = isFurnished;
        return true;
    }

    //this function is used to take it off the market when the office owner does not want to rent it out    
    function changeIsAvailable(string physicalAddress, bool isAvailable) public returns (bool) {
        require(allOffices[physicalAddress].owner == msg.sender);
        allOffices[physicalAddress].isAvailable = isAvailable;
        return true;
    }
    
    modifier availability(string physicalAddress, uint startDate, uint numDays) {
        require(allOffices[physicalAddress].isAvailable == true); //Aalim version wants to change
        for (uint index = 0; index < allOffices[physicalAddress].bookings.length; index++) {
            rental storage booking = allOffices[physicalAddress].bookings[index];
            
            uint existingEndDate = booking.startDate + booking.numDays * 1 days;
            uint requestedEndDate = startDate + numDays * 1 days;
            require(startDate < booking.startDate && requestedEndDate < booking.startDate); //booking starts and ends before next booking starts
            require(startDate > existingEndDate);                
        }
        _;
    }

    //called by User (renter)
    //assumption is that the user wanting to rent the office has access to view the mapping of all addresses and their prices 
  /*  
    function rentOffice(string physicalAddress, uint startDate, uint numDays) public availability(physicalAddress, startDate, numDays) returns (bool) {
        require(allOffices[physicalAddress].exists == true);
        address renter = msg.sender;
        office myOffice = allOffices[physicalAddress];
        rental[] bookings = myOffice.bookings;
        rental r = rental(renter, physicalAddress, startDate, numDays, true);
        bookings.push(r);
        //bookings.push(rental(renter, physicalAddress, startDate, numDays, true));
        return true;
        
    }*/
    
   /* function respondRentRequest(address renter, string physicalAddress, uint numDays) {
        uint totalRent;
        totalRent = allOffices[_physicalAddress].dailyRent*numDays;
        
        if(renter.balance >= totalRent && //room is available during all these days) {
            //set office to occupied during these days
            //assign this renter to this office for those days
            //allOffices[physicalAddress].renter?? = renter;
            event rentRequestAccepted(address officeRenter, uint startDate, uint numDays, uint _timestamp);
        } else { 
            event rentRequestDenied(address officeRenter, uint startDate, uint numDays, uint _timestamp);
            //should provide a reason
        }
   }    
*/
    
    //the renter will call this at the end of their stay 
	/** @dev Transfers total rent due (in wei) from the renter to the office owner at the end of the renter's stay.
     * @return Flag to denote if the transfer was successfull.
     */
    function payRent(string physicalAddress, uint startDate) public payable returns (bool) {
        office storage myOffice = allOffices[physicalAddress];
        uint endDate;
        //unit totalCost;
        
        for (uint index = 0; index < myOffice.bookings.length; index++) {
            endDate = myOffice.bookings[index].startDate + myOffice.bookings[index].numDays * 1 days;
            if (myOffice.bookings[index].startDate == startDate && now > endDate) {
                myOffice.owner.transfer(msg.value);
            break;
            }
            //require(msg.sender.balance >= totalCost)
        }
        return true;
    }
    
}