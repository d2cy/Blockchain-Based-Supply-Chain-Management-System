import React , { useContext } from "react";
import ReactDOM from "react-dom";
import Web3 from 'web3';
import Button from 'react-bootstrap/Button';
import Form from 'react-bootstrap/Form';
import { BlockchainContext } from "../App";


export default function Home() {
    const { accounts , instance } = useContext(BlockchainContext);
    const addCustomer = async (event) => {
        try{
            event.preventDefault();
            const customerName = document.getElementById('customerName').value;
            let x = await instance.methods.addCustomer(customerName).send({from: accounts[0]});
            console.log(x);
            alert("Customer added successfully");

        }
        catch(error){
            console.log(error);
        }
    }
   
  return (
    <div>
      <h1>Home</h1>
      <hr />
      <h2> Register as Customer</h2>
        <Form onSubmit={addCustomer}>
            <Form.Group>
                <Form.Label> Name</Form.Label>
                <Form.Control type='text' placeholder='Enter Name' id='customerName'/>
                <Button variant='primary' type='submit'>
                    Submit
                </Button>

            </Form.Group>

        </Form>
        <hr />
       
    </div>
  );
}
