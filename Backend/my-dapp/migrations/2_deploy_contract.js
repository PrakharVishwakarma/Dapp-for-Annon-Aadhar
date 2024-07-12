const AadhaarVerification = artifacts.require("AadhaarVerification");

module.exports = function(deployer) {
    // Replace '0xYourAnonVerifierAddress' with the actual address of the Anon Aadhaar verifier contract
    const anonVerifierAddress = '0xb7afd4631eE834080F4897C2CEa059a537604485';
    deployer.deploy(AadhaarVerification, anonVerifierAddress);
};
