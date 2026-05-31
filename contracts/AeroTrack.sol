// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/**
 * @title AeroTrack
 * @notice This contract tracks the lifecycle of airplane spare parts
 *         on the Ethereum blockchain, ensuring provenance and security.
 * @dev Implements Role-Based Access Control using modifiers and
 *      traceability using Events.
 */
contract AeroTrack {

    // ================================================================
    // ENUMS
    // Tracks the physical state of a part throughout its lifecycle
    // ================================================================
    enum PartStatus {
        Manufactured,  // 0 - Just created by the manufacturer
        InTransit,     // 1 - Being transferred to a new owner
        Installed,     // 2 - Installed on an aircraft after maintenance
        Retired        // 3 - Permanently decommissioned
    }

    // ================================================================
    // STRUCTS
    // Defines all attributes of a single airplane spare part
    // ================================================================
    struct Part {
        uint256 serialNumber;   // Unique identifier for the part
        string partName;        // Description (e.g. "Turbine Blade")
        address manufacturer;   // Ethereum address of the manufacturer
        address currentOwner;   // Ethereum address of the current owner
        PartStatus status;      // Current lifecycle status
        bool exists;            // Security flag: prevents default empty struct confusion
    }

    // ================================================================
    // STATE VARIABLES
    // Stored permanently on the blockchain
    // ================================================================

    // The regulatory authority (FAA/EASA) - set to contract deployer
    address public regulatoryAuthority;

    // Maps each serial number to its corresponding Part struct
    // Using a mapping instead of an array avoids expensive Gas iteration
    mapping(uint256 => Part) public parts;

    // ================================================================
    // EVENTS
    // Written to transaction logs - cheap and permanently traceable
    // The 'indexed' keyword allows fast filtering by serial number
    // ================================================================
    event PartManufactured(uint256 indexed serialNumber, string partName, address manufacturer);
    event OwnershipTransferred(uint256 indexed serialNumber, address oldOwner, address newOwner);
    event MaintenanceLogged(uint256 indexed serialNumber, address mechanic, string report);

    // ================================================================
    // CONSTRUCTOR
    // Runs once at deployment - assigns the deployer as the authority
    // ================================================================
    constructor() {
        regulatoryAuthority = msg.sender;
    }

    // ================================================================
    // MODIFIERS
    // Reusable security checks that run before function execution
    // The underscore '_' means: "now execute the actual function body"
    // ================================================================

    // Ensures the part exists before any interaction
    modifier partExists(uint256 _serialNumber) {
        require(parts[_serialNumber].exists == true, "Part does not exist.");
        _;
    }

    // Ensures only the current owner can modify the part
    modifier onlyPartOwner(uint256 _serialNumber) {
        require(parts[_serialNumber].currentOwner == msg.sender, "Not the owner.");
        _;
    }

    // ================================================================
    // CORE FUNCTIONS
    // ================================================================

    /**
     * @notice Registers a newly manufactured part on the blockchain
     * @param _serialNumber Unique serial number of the part
     * @param _partName Name or description of the part
     */
    function manufacturePart(uint256 _serialNumber, string memory _partName) public {
        // Prevent duplicate serial numbers
        require(parts[_serialNumber].exists == false, "Serial Number taken!");

        // Store the new part in the mapping
        parts[_serialNumber] = Part({
            serialNumber: _serialNumber,
            partName: _partName,
            manufacturer: msg.sender,
            currentOwner: msg.sender, // Manufacturer is the first owner
            status: PartStatus.Manufactured,
            exists: true
        });

        // Announce the creation to the outside world
        emit PartManufactured(_serialNumber, _partName, msg.sender);
    }

    /**
     * @notice Transfers ownership of a part to a new address
     * @dev Protected by partExists and onlyPartOwner modifiers
     * @param _serialNumber Serial number of the part to transfer
     * @param _newOwner Ethereum address of the new owner
     */
    function transferPart(uint256 _serialNumber, address _newOwner)
        public
        partExists(_serialNumber)
        onlyPartOwner(_serialNumber)
    {
        // Prevent accidental transfer to the zero address
        require(_newOwner != address(0), "Invalid address.");

        address oldOwner = parts[_serialNumber].currentOwner;

        // Update ownership and status
        parts[_serialNumber].currentOwner = _newOwner;
        parts[_serialNumber].status = PartStatus.InTransit;

        // Log the transfer event
        emit OwnershipTransferred(_serialNumber, oldOwner, _newOwner);
    }

    /**
     * @notice Logs a maintenance report for a part
     * @dev Only the current owner (e.g. airline/mechanic) can log maintenance
     * @param _serialNumber Serial number of the maintained part
     * @param _report Maintenance report string
     */
    function logMaintenance(uint256 _serialNumber, string memory _report)
        public
        partExists(_serialNumber)
        onlyPartOwner(_serialNumber)
    {
        // Emit event - stored in transaction logs cheaply
        emit MaintenanceLogged(_serialNumber, msg.sender, _report);

        // Update status to reflect active use
        parts[_serialNumber].status = PartStatus.Installed;
    }
}
