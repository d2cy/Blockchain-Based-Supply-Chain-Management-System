import Button from 'react-bootstrap/Button';
import Form from 'react-bootstrap/Form';
import Stack from 'react-bootstrap/Stack';
import { BlockchainContext } from "../App";
import { useContext } from 'react';
export default function Supplier() {
    const { accounts , instance } = useContext(BlockchainContext);
    const setLimit = async (event) => {
        try{
            event.preventDefault();
            const limit = document.getElementById('limit').value;
            let x = await instance.methods.set_limit(limit).send({from: accounts[0]});
            console.log(x);
            alert("Limit set successfully");
        }
        catch(error){
            console.log(error);
        }
    }
    const setPrice = async (event) => {
        try{
            event.preventDefault();
            const price = document.getElementById('price').value;
            let x = await instance.methods.setPartPrice(price).send({from: accounts[0]});
            console.log(x);
            alert("Price set successfully");
        }
        catch(error){
            console.log(error);
        }
    }
    return (
        <div>
            <h1>Supplier</h1>
         <hr />
         <h2> Set Limit </h2>
        <Form onSubmit={setLimit}>
            <Form.Group>
                <Form.Label>Limit</Form.Label>
                <Form.Control type='text' placeholder='Enter Limit' id='limit'/>
                <Button variant='primary' type='submit'>
                    Submit
                </Button>

            </Form.Group>
        </Form>
        <h2> Set Price of Parts</h2>
        <Form onSubmit={setPrice}>
            <Form.Group>
                <Form.Label> Price</Form.Label>
                <Form.Control type='text' placeholder='Enter Price' id='price'/>
                <Button variant='primary' type='submit'>
                    Submit
                </Button>
            </Form.Group>
        </Form>
        </div>
    );
    }
