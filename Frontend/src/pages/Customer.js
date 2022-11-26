import Button from 'react-bootstrap/Button';
import Form from 'react-bootstrap/Form';
import Stack from 'react-bootstrap/Stack';
import React , { useContext, useState } from 'react';
import { BlockchainContext } from "../App";
import { render } from 'react-dom';
export default function Customer() {
    const [brand, setBrand] = useState()
    const { accounts , instance } = useContext(BlockchainContext);
    
    const handleBrand = (event) => {
        setBrand(event.target.value);
    }
    
    const getPrice = async (event) => {
        try{
            console.log("captured brand is "+brand);
            event.preventDefault();
            // const cname = document.getElementsByName('car').value;
            let x = await instance.methods.getCarPrice(brand).call();
            // console.log(cname);
            alert("Price of car is "+x);
            
        }
        catch(error){
            console.log(error);
        }
    }
    const buyCar = async (event) => {
        try{

            event.preventDefault();
            // const cname = document.getElementsByName('car').value;
            let price = await instance.methods.getCarPrice(brand).call();

            let x = await instance.methods.purchaseCar(brand).send({from: accounts[0], value: price*1000000000000000000});

            console.log(x);
            alert("Car bought successfully");
        }
        catch(error){
            console.log(error);
        }
    }
    const getCarId = async (event) => {
        try{
            event.preventDefault();
            let x = await instance.methods.getcarID().call({from: accounts[0]});
            console.log(x);
            // alert("Car Id is "+x);

        }
        catch(error){
            console.log(error);
        }
    }
    const verifyCar = async (event) => {
        try{
            event.preventDefault();
            const carId = document.getElementById('carID').value;
            let x = await instance.methods.verify(carId).call({from: accounts[0]});
            console.log(x);
                // alert("Car is verified");
            let y=" ";
            for(let i = 0; i < x.length; i++) 
            {
                y+=x[i] + "\n";
            };
            alert(y);

        }
        catch(error){
            console.log(error);
        }
    }

    return (
      <div>
        <h1>Customer</h1>
        <hr />
        <h2> Get Price of Car</h2>
        <Form onSubmit={getPrice} >
            <Form.Group onChange={handleBrand}>
                <Form.Check type='radio' label='Tata' name='car' id='Tata' value='Tata' /> 
                <Form.Check type='radio' label='Maruti' name='car' id='Maruti' value='Maruti' />
                <Button variant='primary' type='submit'>
                    Get price
                </Button>
            </Form.Group>
        </Form>
        <hr />
        <h2> Buy Car</h2>
        <Form onSubmit={buyCar}>
            <Form.Group onChange={handleBrand}>
                <Form.Check type='radio' label='Tata' name='car' id='Tata' value='Tata' />
                <Form.Check type='radio' label='Maruti' name='car' id='Maruti' value='Maruti' />
                <Button variant='primary' type='submit'>
                    Buy
                </Button>
            </Form.Group>
        </Form>
        <hr />
        <h2> Get Car ID</h2>
        <Form onSubmit={getCarId}>  
            <Form.Group>
                <Button variant='primary' type='submit'>
                    Get Car ID
                </Button>

            </Form.Group>
        </Form>
        <hr />

        <h2> Verify Car</h2>
        <Form onSubmit={verifyCar}>
            <Form.Group>
                {/* <Form.Label> Car ID</Form.Label> */}
                
                <Form.Control type='text' placeholder='Enter Car ID' id='carID' />
                <br />
                <Button variant='primary' type='submit'>
                    Submit
                </Button>
                
            </Form.Group>
        </Form>
        
      </div>
    );
  }
  