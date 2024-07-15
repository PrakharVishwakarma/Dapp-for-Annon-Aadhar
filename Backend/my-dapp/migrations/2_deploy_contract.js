const AadhaarVerification = artifacts.require("AadhaarVerification");

module.exports = function(deployer) {
    const anonVerifierAddress = '0x4A58a77BC0Cc29077D1AF9e11CA096bA4772eF9C';
    deployer.deploy(AadhaarVerification, anonVerifierAddress);
};
