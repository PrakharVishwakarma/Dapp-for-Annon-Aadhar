// SPDX-License-Identifier: MIT
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

    function verifyUser(address _userAddress, bytes32 _zkProof) public {
        require(zkProofs[_userAddress] == _zkProof, "Invalid zero-knowledge proof");

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
