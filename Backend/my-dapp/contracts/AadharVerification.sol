pragma solidity ^0.8.0;

contract AadhaarVerification {
    struct User {
        uint256 id;
        string name;
        uint256 aadhaarNumber;
        bool verified;
    }

    mapping(address => User) public users;
    mapping(address => bytes32) public zkProofs;

    uint256 public nextUserId;
    address public anonVerifier;

    event UserRegistered(address indexed userAddress, uint256 userId, string name, uint256 aadhaarNumber);
    event UserVerified(address indexed userAddress);

    modifier onlyAdmin() {
        // Implement access control logic here
        _;
    }

    constructor(address _anonVerifier) {
        anonVerifier = _anonVerifier;
    }

    function registerUser(string memory _name, uint256 _aadhaarNumber) public {
        require(users[msg.sender].id == 0, "User already registered");
        nextUserId++;
        users[msg.sender] = User(nextUserId, _name, _aadhaarNumber, false);
        emit UserRegistered(msg.sender, nextUserId, _name, _aadhaarNumber);
    }

    function submitProof(bytes32 _zkProof) public {
        zkProofs[msg.sender] = _zkProof;
    }

    function verifyUser(address _userAddress, bytes32 _zkProof) public onlyAdmin {
        bool isVerified = IAnonVerifier(anonVerifier).verifyProof(_zkProof);
        require(isVerified, "Zero-knowledge proof verification failed");
        users[_userAddress].verified = true;
        emit UserVerified(_userAddress);
    }

    function getUserDetails(address _userAddress) public view returns (uint256, string memory, uint256, bool) {
        User memory user = users[_userAddress];
        return (user.id, user.name, user.aadhaarNumber, user.verified);
    }
}

interface IAnonVerifier {
    function verifyProof(bytes32 _zkProof) external view returns (bool);
}


// // SPDX-License-Identifier: MIT
// pragma solidity ^0.8.0;

// contract AadhaarVerification {
//     // Struct to store user details
//     struct User {
//         uint256 id;
//         string name;
//         uint256 aadhaarNumber;
//         bool verified;
//     }

//     // Mapping to store users
//     mapping(address => User) public users;

//     // Mapping to store zero-knowledge proof hash
//     mapping(address => bytes32) public zkProofs;

//     // Counter for user IDs
//     uint256 public nextUserId;

//     // Address of the Anon Aadhaar verifier contract
//     address public anonVerifier;

//     // Event to log user registration
//     event UserRegistered(address indexed userAddress, uint256 userId, string name, uint256 aadhaarNumber);

//     // Event to log user verification
//     event UserVerified(address indexed userAddress);

//     // Constructor to set the Anon Aadhaar verifier address
//     constructor(address _anonVerifier) {
//         anonVerifier = _anonVerifier;
//     }

//     // Function to register a new user
//     function registerUser(string memory _name, uint256 _aadhaarNumber) public {
//         // Check if user is already registered
//         require(users[msg.sender].id == 0, "User already registered");

//         // Increment user ID counter
//         nextUserId++;

//         // Store user details
//         users[msg.sender] = User(nextUserId, _name, _aadhaarNumber, false);

//         // Emit event for user registration
//         emit UserRegistered(msg.sender, nextUserId, _name, _aadhaarNumber);
//     }

//     // Function to submit zero-knowledge proof
//     function submitProof(bytes32 _zkProof) public {
//         // Store the zero-knowledge proof hash
//         zkProofs[msg.sender] = _zkProof;
//     }

//     // Function to verify user using Aadhaar verification service
//     function verifyUser(address _userAddress, bytes32 _zkProof) public {
//         // Check if the zero-knowledge proof matches the stored proof
//         require(zkProofs[_userAddress] == _zkProof, "Invalid zero-knowledge proof");

//         // Call the Anon Aadhaar verifier contract to verify the zero-knowledge proof
//         bool isVerified = IAnonVerifier(anonVerifier).verifyProof(_zkProof);

//         // Update the user's verification status based on the verification result
//         require(isVerified, "Zero-knowledge proof verification failed");
//         users[_userAddress].verified = true;

//         // Emit event for user verification
//         emit UserVerified(_userAddress);
//     }

//     // Function to get user details by address
//     function getUserDetails(address _userAddress) public view returns (uint256, string memory, uint256, bool) {
//         User memory user = users[_userAddress];
//         return (user.id, user.name, user.aadhaarNumber, user.verified);
//     }
// }

// // Interface for the Anon Aadhaar verifier contract
// interface IAnonVerifier {
//     function verifyProof(bytes32 _zkProof) external view returns (bool);
// }
