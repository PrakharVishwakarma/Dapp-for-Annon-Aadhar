import React, { useState, useEffect } from 'react';
import Web3 from 'web3';
import AadhaarVerificationContract from './contracts/AadhaarVerification.json'; // Adjust the path if needed

const App = () => {
  const [web3, setWeb3] = useState(null);
  const [accounts, setAccounts] = useState([]);
  const [contract, setContract] = useState(null);
  const [userName, setUserName] = useState('');
  const [aadhaarNumber, setAadhaarNumber] = useState('');
  const [zkProof, setZkProof] = useState('');
  const [userDetails, setUserDetails] = useState(null);

  useEffect(() => {
    const initWeb3 = async () => {
      if (window.ethereum) {
        const web3 = new Web3(window.ethereum);
        try {
          await window.ethereum.enable();
          setWeb3(web3);
          const accounts = await web3.eth.getAccounts();
          setAccounts(accounts);
          const networkId = await web3.eth.net.getId();
          const deployedNetwork = AadhaarVerificationContract.networks[networkId];
          const contract = new web3.eth.Contract(
            AadhaarVerificationContract.abi,
            deployedNetwork && deployedNetwork.address,
          );
          setContract(contract);
        } catch (error) {
          console.error("Failed to load web3, accounts, or contract.");
        }
      }
    };
    initWeb3();
  }, []);

  const registerUser = async () => {
    if (contract && accounts.length > 0) {
      await contract.methods.registerUser(userName, aadhaarNumber).send({ from: accounts[0] });
    }
  };

  const submitProof = async () => {
    if (contract && accounts.length > 0) {
      await contract.methods.submitProof(web3.utils.sha3(zkProof)).send({ from: accounts[0] });
    }
  };

  const verifyUser = async () => {
    if (contract && accounts.length > 0) {
      try {
        await contract.methods.verifyUser(accounts[0], web3.utils.sha3(zkProof)).send({ from: accounts[0] });
      } catch (error) {
        console.error("Verification failed:", error);
      }
    }
  };  

  const getUserDetails = async () => {
    if (contract && accounts.length > 0) {
      const details = await contract.methods.getUserDetails(accounts[0]).call();
      setUserDetails(details);
    }
  };

  return (
    <div className='mainContainer'>
      <div className="headContainer">
        <h1>Aadhaar Verification DApp</h1>
      </div>
      
      <div className='regUserBox'>

        <h2>Register User</h2>

        <input type="text" placeholder="Name" value={userName} onChange={(e) => setUserName(e.target.value)} />
        <input type="text" placeholder="Aadhaar Number" value={aadhaarNumber} onChange={(e) => setAadhaarNumber(e.target.value)} />

        <button onClick={registerUser}>Register</button>

      </div>


      <div className='SubZkpBox'>
        <h2>Submit Zero-Knowledge Proof</h2>

        <input type="text" placeholder="Zero-Knowledge Proof" value={zkProof} onChange={(e) => setZkProof(e.target.value)} />
        <button onClick={submitProof}>Submit Proof</button>
      </div>


      <div className='VeriUserBox'>
        <h2>Verify User</h2>
        <button onClick={verifyUser}>Verify</button>
      </div>

      <div className='userDtlBox'>

        <button onClick={getUserDetails}>Get User Details</button>
        {userDetails && (
          <div>
            <p>ID: {userDetails[0]}</p>
            <p>Name: {userDetails[1]}</p>
            <p>Aadhaar Number: {userDetails[2]}</p>
            <p>Verified: {userDetails[3] ? 'Yes' : 'No'}</p>
          </div>
        )}
      </div>

    </div>
  );
};

export default App;
