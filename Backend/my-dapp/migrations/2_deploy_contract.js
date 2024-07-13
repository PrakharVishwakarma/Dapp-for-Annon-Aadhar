const AadhaarVerification = artifacts.require("AadhaarVerification");

module.exports = function (deployer) {
  const anonVerifierAddress = "0xc5998b1aEa4723B8D19786EfF856EC5cb7F211B2";
  deployer.deploy(AadhaarVerification, anonVerifierAddress);
};
