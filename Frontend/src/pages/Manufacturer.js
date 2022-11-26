import { BlockchainContext } from "../App";
import { useContext ,useState } from 'react';
import Button from 'react-bootstrap/Button';
import Form from 'react-bootstrap/Form';
import Stack from 'react-bootstrap/Stack';
import { BigNumber} from 'ethers';
export default function Manufacturer() {
    const [disable, setDisable] = useState(false);

    const { web3,  accounts , instance } = useContext(BlockchainContext);
    const purchaseTyre = async (event) => {
        try{
            event.preventDefault();
            const quantity = document.getElementById('quantity').value;
            let y = await instance.methods.getPartPrice().call();
            let x = await instance.methods.purchaseTyre(quantity).send({from: accounts[0], value: quantity*y*1000000000000000000});
            console.log(x);
            alert("Tyre purchased successfully");
            setDisable(false);
        }
        catch(error){
            console.log(error);
        }
    }
    const placeBid = async (event) => {
        try{
            event.preventDefault();
            const bid = document.getElementById('bid').value;
            const quantity = document.getElementById('quantityB').value;
            let total = bid*quantity;
            let x = await instance.methods.place_bid(quantity,bid).send({from: accounts[0], value: total*1000000000000000000});
            console.log(x);
            alert("Bid placed successfully");
        }
        catch(error){
            console.log(error);
        }
    }
    const getTyrePrice = async (event) => {
        try{
            event.preventDefault();
            let x = await instance.methods.getPartPrice().call();
            console.log(x);
            alert("Price of tyre is "+x);
        }
        catch(error){
            console.log(error);
        }
    }
    const getBid = async (event) => {
        try{
            event.preventDefault();
            let x = await instance.methods.showbid().call();
            console.log(x);
            alert(x);
        }
        catch(error){
            console.log(error);
            alert("Bid Not Placed");
        }
    }
    const makeProduct = async (event) => {
        try{
            event.preventDefault();
            let x = await instance.methods.makeProduct().send({from: accounts[0]});
            console.log(x);
            alert("Product made successfully");
        }
        catch(error){
            console.log(error);
        }
    }
    const setCarPrice = async (event) => {
        try{
            event.preventDefault();
            const price = document.getElementById('price').value;
            let x = await instance.methods.setCarPrice(price).send({from: accounts[0]});
            console.log(x);
            alert("Price set successfully");
        }
        catch(error){
            console.log(error);
        }
    }


  return (
    <div>
      <h1>Manufacturer</h1>
      <hr />
      <Stack direction="horizontal" gap={5}>
      <h2>
        Buy Tyres:
      </h2>
      

      <Form onSubmit={purchaseTyre}>
        <Form.Group>
        <Stack direction="vertical" gap={2}>
            {/* <Form.Label>Quantity</Form.Label> */}
            <Form.Control type='text' placeholder='Enter Quantity' id='quantity'/>
            <Button variant='primary' type='submit'>
                Submit
            </Button>
        </Stack>
        </Form.Group>
        </Form>
        
        <h2>
            Place Bid:
        </h2>
        <Form onSubmit={placeBid}>
            <Form.Group>
                <Stack direction="vertical" gap={2}>
                {/* <Form.Label>Quantity</Form.Label> */}
                <Form.Control type='text' placeholder='Enter Quantity' id='quantityB'/>
                {/* <Form.Label>Price</Form.Label> */}
                <Form.Control type='text' placeholder='Enter Price' id='bid' />
                <Button variant='primary' type='submit' disabled={disable}>
                    Submit
                </Button>
                </Stack>
            </Form.Group>
        </Form>
        </Stack>
        <br />
        <Stack direction="horizontal" gap={5}>
        <Stack direction="horizontal" gap={3}>
        <h2>
            Check Tyre Price:
        </h2>

        <Form onSubmit={getTyrePrice}>
            <Form.Group>
                <Button variant='primary' type='submit'>
                    Get price
                </Button>
            </Form.Group>
        </Form>
        </Stack>
        <Stack direction="horizontal" gap={3}>
        <h2>
            Check Bid:
        </h2>
        <Form onSubmit={getBid}>
            <Form.Group>
                <Button variant='primary' type='submit'>
                    Get Bid
                </Button>
            </Form.Group>
        </Form>
        </Stack>
        </Stack>
        <br />
        <Stack direction="horizontal" gap={4}>
        <h2>
            Make product:
        </h2>
        <Form onSubmit={makeProduct}>
            <Form.Group>
                <Button variant='primary' type='submit'>
                    Make Product
                </Button>
            </Form.Group>
        </Form>
        </Stack>
        <br />
        <Stack direction="horizontal" gap={4}>
        <h2>
            Set Car Price :
            </h2>
            <Form onSubmit={setCarPrice}>
                <Form.Group>
                    {/* <Form.Label>Price</Form.Label> */}
                    <br />
                   <Stack direction="vertical" gap={2}>
                    <Form.Control type='text' placeholder='Enter Price' id='price'/>
                   
                    <Button variant='primary' type='submit'>
                        Submit
                    </Button>
                    </Stack>
                </Form.Group>
            </Form>
        </Stack>
    </div>
  );
}
