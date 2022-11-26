import React , { useContext } from "react";
import ReactDOM, { render } from "react-dom";
import Web3 from 'web3';
import Button from 'react-bootstrap/Button';
import Form from 'react-bootstrap/Form';
import Stack from 'react-bootstrap/Stack';

import { BlockchainContext } from "../App";
export default function Admin() 
{
 
  const { accounts , instance } = useContext(BlockchainContext);
  const addSupplier = async (event) => {
    try{
        event.preventDefault();
        const supplierAddress = document.getElementById('supplierAddress').value;
        const supplierName = document.getElementById('supplierName').value;
        const supplierType = document.getElementById('supplierType').value;
        let x = await instance.methods.addSupplier(supplierAddress, supplierName, supplierType).send({from: accounts[0]});
        console.log(x);
        alert("Supplier added successfully");
       // console.log(instance);
    }
    catch(error){
        console.log(error);
    }
  }
  const addManufacturer = async (event) => {
    try{
        event.preventDefault();
        const manufacturerAddress = document.getElementById('manufacturerAddress').value;
        const manufacturerName = document.getElementById('manufacturerName').value;
        let x =await instance.methods.addManufacturer(manufacturerAddress, manufacturerName).send({from: accounts[0]});
        console.log(x);
        alert("Manufacturer added successfully");
        // console.log(instance);
    }
    catch(error){
        console.log(error);
    }
  }
  

    

    return (
      <div>
  
         <h1>Admin Panel</h1>

         {/* <button onSubmit="auth()">Login </button> */}

        <hr>    
        </hr>
        <Stack direction="horizontal" gap={5}>
        <h2> Add Suppliers :</h2> 
        
        </Stack>
        
        <Stack direction="horizontal" gap={5}>
      
        
      <Stack direction="vertical" gap={3}>

        <Form onSubmit={addSupplier}>
          <Form.Group >
            <Form.Label>Supplier Address</Form.Label>
            <Form.Control type="text" placeholder="Enter Supplier Address" id="supplierAddress" />
          </Form.Group>

          <Form.Group >
            <Form.Label>Supplier Name</Form.Label>
            <Form.Control type="text" placeholder="Enter Supplier Name" id="supplierName" />
          </Form.Group>
          <Form.Group>
            <Form.Label>Supplier Type</Form.Label>
            <Form.Control type="text" placeholder="Enter Supplier Type" id="supplierType" />
          </Form.Group>

          <br />
          <Button variant="primary" type="submit">
            Submit
          </Button>
          </Form>
          </Stack>
          {/* <hr /> */}
          <Stack direction="vertical" gap={2}>
          <h2> Add Manufacturers:</h2>
          <Form onSubmit={addManufacturer}>
            <Form.Group >
              <Form.Label>Manufacturer Address</Form.Label>
              <Form.Control type="text" placeholder="Enter Manufacturer Address" id="manufacturerAddress" />
            </Form.Group>
            <Form.Group>
              <Form.Label>Manufacturer Name</Form.Label>
              <Form.Control type="text" placeholder="Enter Manufacturer Name" id="manufacturerName" />
            </Form.Group>
            <br />
            <Button variant="primary" type="submit">
              Submit
            </Button>
          </Form>
          </Stack>
          </Stack>
      

      </div>
    );
  }

