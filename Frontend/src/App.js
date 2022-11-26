import './App.css';
import './index.css';
import Nav from './pages/Navbar';
import Home from './pages/Home';
import Admin from './pages/admin';
import Manufacturer from './pages/Manufacturer';
import Supplier from './pages/Supplier';
import Customer from './pages/Customer';
import Web3 from 'web3';
import React , { useEffect , createContext} from 'react';
import { useState } from "react";

import { Route, Routes , Navigate } from 'react-router-dom';
import SupplyChainManagement from "./contracts/SupplyChainManagement.json"

export const BlockchainContext = createContext();

const App = () => {
  const [blockchain, setBlockchain] = useState({
    web3:null,
    accounts: null,
    instance: null
  })
  const [role,setRole] = useState(null);

  useEffect(() => {
    const init = async () => {
        let provider = window.ethereum;
        if (typeof provider !== 'undefined') 
        provider
        .request({ method: 'eth_requestAccounts' })
        .then((accounts) => {
          console.log(`Selected account is ${accounts[0]}`);
        })
        const web3 = new Web3(provider);
        const id = await web3.eth.net.getId();
        const deployedNetwork = SupplyChainManagement.networks[id];
        const instance = new web3.eth.Contract(
          SupplyChainManagement.abi,deployedNetwork.address
          );
        const accounts = await web3.eth.getAccounts();
        setBlockchain({
          web3: web3,
          accounts: accounts,
          instance: instance});
          console.log(instance);
          let x = await instance.methods.getRole().call({from: accounts[0]});
          console.log(x[0]);
          console.log(x[1]);
          setRole(x[0]);
    };
    init();
  }, []);
 
  return (<div className="App">
     <Nav />
    <div className="container">
      <BlockchainContext.Provider value={blockchain}>
    <Routes>
      <Route path="/" element={<Home />} />
      {/* {role=='Owner' ? ( <Route  path="/admin" element={<Admin />} /> ) : (<Navigate to="/"  /> )} */}
      <Route path="/admin" element={role=='Owner' ? <Admin /> : <Navigate to="/" />} />
      <Route path="/manufacturer" element={role=='MAN' ? <Manufacturer /> : <Navigate to="/" />} />
      <Route path='/supplier' element={role=='SUP' ? <Supplier /> : <Navigate to="/" /> } />
      <Route path='/customer' element={role=='CUS' ? <Customer /> : <Navigate to="/" /> } />
   
      
     
    </Routes>
   
    </BlockchainContext.Provider>
    </div> 
     </div>);
}
    
 

export default App;
