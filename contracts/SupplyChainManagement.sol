// SPDX-License-Identifier: Unlicensed
pragma solidity >=0.4.22 <0.9.0;

contract SupplyChainManagement{

   address public owner = msg.sender;
   enum Roles{
       CUS,
       MAN,
       SUP,
       XYZ
   }
    struct Supplier{
        string name;
        address id;
        string partType;
        uint part_limit;       
        Roles role;
    }
    struct Manufacturer{
        string name;
        address id;
        uint tyre_limit;
        uint body_limit;
        Roles role;
    }
    struct Customer{
        string name;
        address id;
        Roles role;
    }
    struct bid_tuple{
        uint price;
        uint quantity;
        address id;
    }
    struct partType{
         uint id;
         string brand;
         string part_type;
         address owner;
    }
    struct product{
        uint id;
        string brand;
        uint tyre_id;
        uint body_id;
        address owner;
    }
    mapping(address=>uint) private productPrice;
    mapping(address=>uint) private partPrice;
    mapping(address=>Supplier) private suppliers;
    mapping(address=>Manufacturer) private manufacturers;
    mapping(address=>Customer) private customers;
    // mapping(address=>Supplier) public suppliers;
    // mapping(address=>Manufacturer) public manufacturers;
    // mapping(address=>Customer) public customers;
    mapping(string=>uint[]) private s_shelf;
    mapping(string=>uint[]) private m_shelf_body;
    mapping(string=>uint[]) private m_shelf_tyre;
    mapping(uint=>partType) private parts;
    mapping(string=>uint[]) private product_shelf;
    mapping(uint=>product) private products;
    mapping(address=>uint) private carOwner;
    mapping(string=>address) private name2Addr;
    mapping(string=>bid_tuple) private bids;
    uint pid=0;
    function getRole() public view returns(string[2] memory){
        string[2] memory response;
        if(msg.sender==owner)
        {
            response[0]="Owner";
            response[1]="Owner";
            return response;
        }
        if(manufacturers[msg.sender].role == Roles.MAN)
         {   
            response[0]="MAN";
            response[1]=manufacturers[msg.sender].name;
            return response;
         }
        else if(suppliers[msg.sender].role == Roles.SUP)
         { 
            response[0]="SUP";
            response[1]=suppliers[msg.sender].name;
            return response;
         }
        else if(customers[msg.sender].role == Roles.CUS)
         { 
            response[0]="CUS";
            response[1]=customers[msg.sender].name;
            return response;
        }
        else
          {  
               response[0]="XYZ";
            response[1]="a";
            return response;
          }
    }
//Access Control
    modifier isOwner() {
        require(owner==msg.sender,"Not Owner");
        _;

    }
    modifier isManufacturer(){
        require(manufacturers[msg.sender].role == Roles.MAN,"Not Manufacturer"); 
        _;
    }
     modifier isSupplier(){
        require(suppliers[msg.sender].role == Roles.SUP,"Not Supplier"); 
        _;
    }
    modifier isCustomer(){
        require(customers[msg.sender].role == Roles.CUS,"Not Customer");
        _;
    }
// 

//Add Actors 
    function addSupplier(address _account,string memory _name,string memory _partType) public isOwner{
            Supplier memory tmp = Supplier(_name,_account,_partType,0,Roles.SUP);
            suppliers[_account]=tmp;
            name2Addr[_name] = _account;
    }
    function addManufacturer(address _account,string memory _name) public isOwner{
            Manufacturer memory tmp = Manufacturer(_name,_account,0,0,Roles.MAN); 
            manufacturers[_account]=tmp;
            name2Addr[_name] = _account;
         }

    function addCustomer(string memory _name) public
    {
        customers[msg.sender]=Customer(_name,msg.sender,Roles.CUS);
        name2Addr[_name] = msg.sender;
    }
     function create_Parts(uint _limit,string memory _partType,string memory _name) internal{
        for(uint i=0;i<_limit;i++)
        {
            s_shelf[_name].push(pid);
            parts[pid]=partType(pid,_name,_partType, msg.sender);
            pid++;
        }
    }
    
     function set_limit(uint _limit) public isSupplier{ 
        uint old_remaining = suppliers[msg.sender].part_limit;
        suppliers[msg.sender].part_limit=_limit;
        create_Parts(_limit - old_remaining,suppliers[msg.sender].partType,suppliers[msg.sender].name);
    }

   uint x;

     function purchaseTyre(uint quantity)  public payable isManufacturer{
        
        uint total;    
        if (keccak256(abi.encodePacked(manufacturers[msg.sender].name)) == keccak256(abi.encodePacked('Tata'))) {
            
            uint min = suppliers[name2Addr['MRF']].part_limit>quantity?quantity:suppliers[name2Addr['MRF']].part_limit;
            uint cost = partPrice[name2Addr['MRF']];
            total=min*cost;
            uint value = msg.value;
            total = total * (1 ether);
            require(value >= total,"Insufficient balance");
            suppliers[name2Addr['MRF']].part_limit-=min;
            sendmoneytoName(total, 'MRF');
            if(value - total > 0)
                sendmoneytoAdd(value - total, msg.sender);
            for(uint i=0;i<min;i++)
            {
                uint index = s_shelf['MRF'].length-1;
                m_shelf_tyre[manufacturers[msg.sender].name].push(s_shelf['MRF'][index]);  
                parts[s_shelf['MRF'][index]].owner=msg.sender; //Change Owner            
                s_shelf['MRF'].pop();
               
            }
            manufacturers[msg.sender].tyre_limit+=min;
            
        }
        else{
            uint min = suppliers[name2Addr['CEAT']].part_limit>quantity?quantity:suppliers[name2Addr['CEAT']].part_limit;
            uint cost = partPrice[name2Addr['CEAT']];
            total=min*cost;
            total = total * (1 ether);
            require(msg.value >= total,"Insufficient balance");
            suppliers[name2Addr['CEAT']].part_limit-=min;
            sendmoneytoName(total, 'CEAT');
            if(msg.value - total > 0)
                sendmoneytoAdd(msg.value - total, msg.sender);
            for(uint i=0;i<min;i++)
            {
                uint index = s_shelf['CEAT'].length-1;
                m_shelf_tyre[manufacturers[msg.sender].name].push(s_shelf['CEAT'][index]);
                parts[s_shelf['CEAT'][index]].owner=msg.sender; //Change Owner     
                s_shelf['CEAT'].pop();
            }
            manufacturers[msg.sender].tyre_limit+=min;
        }
       

    }
    
    function place_bid(uint quantity,uint price) public payable isManufacturer{
        require(bids[manufacturers[msg.sender].name].id==address(0));
        require(msg.value >= quantity*price * (1 ether));
        delete bid_val;
        if(msg.value > quantity*price * (1 ether))
        	sendmoneytoAdd(msg.value - quantity*price * (1 ether) ,msg.sender);
        x++;    
        bids[manufacturers[msg.sender].name]=bid_tuple(price,quantity,msg.sender);
        if(manufacturers[name2Addr['Tata']].tyre_limit>0 && manufacturers[name2Addr['Maruti']].tyre_limit>0 && x==2)
            {ResourceAllocation();
             showbidhelper();
             delete bids['Tata'];
             delete bids['Maruti'];
             x=0;}
    }
    
    string[6] bid_val;
    
    function showbidhelper() internal{
    
        bid_val[0]="Tata's bid price & quantity";
        bid_val[1]=uint2str(bids['Tata'].price);
        bid_val[2]=uint2str(bids['Tata'].quantity);
        bid_val[3]="Maruti's bid price & quantity";
        bid_val[4]=uint2str(bids['Maruti'].price);
        bid_val[5]=uint2str(bids['Maruti'].quantity);

    }
    

    function showbid() public view returns(string[6] memory){
    
        return bid_val;
    }


     function ResourceAllocation() internal
     {
        uint q1=bids['Tata'].quantity;
        uint q2=bids['Maruti'].quantity;
        uint p1=bids['Tata'].price;
        uint p2=bids['Maruti'].price;

        // Check real requirements.
       
        uint numTyres_Tata=manufacturers[name2Addr['Tata']].tyre_limit; 
        uint numTyres_Maruti=manufacturers[name2Addr['Maruti']].tyre_limit; 
        

        // Optimal Distribution.
        uint trueReqTata; 
        uint trueReqMaruti;
        if(numTyres_Tata<=q1) 
            trueReqTata=numTyres_Tata;
        else 
            trueReqTata=q1;

        if(numTyres_Maruti<=q2) 
            trueReqMaruti=numTyres_Maruti;
        else 
            trueReqMaruti=q2;


        // Give to highest bidder
        address supplierAddress = name2Addr["Vedanta"];
        uint availability = suppliers[supplierAddress].part_limit;

        uint min;
        uint total;

        uint final_tata_alloc=0;
        uint final_maruti_alloc=0;
        if(p1>p2)
        {   
            min = suppliers[name2Addr['Vedanta']].part_limit>trueReqTata?trueReqTata:suppliers[name2Addr['Vedanta']].part_limit;
            total=min*p1;
            uint index = s_shelf['Vedanta'].length-1;
            if(availability>trueReqTata)
            {
                availability-=trueReqTata;
                for(uint i= 0;i<trueReqTata;i++)
                {
                    
                    parts[s_shelf['Vedanta'][index]].owner = name2Addr['Tata'];
                    m_shelf_body['Tata'].push(s_shelf['Vedanta'][index]);              
                    s_shelf['Vedanta'].pop();
                    if(index>=1) index--;
                }
                manufacturers[name2Addr['Tata']].body_limit+=trueReqTata;
                final_tata_alloc=trueReqTata;
            }
            else{
                for(uint i=0;i<availability;i++)
                {
                    parts[s_shelf['Vedanta'][index]].owner = name2Addr['Tata'];
                    m_shelf_body['Tata'].push(s_shelf['Vedanta'][index]);              
                    s_shelf['Vedanta'].pop();
                    if(index>=1) index--;                      ///DOING IT HERE
                }
                manufacturers[name2Addr['Tata']].body_limit+=availability;
                final_tata_alloc=availability;

                availability=0;
                
            }
            suppliers[supplierAddress].part_limit = availability;
            if(availability>0)
            {  

                if(suppliers[name2Addr['Vedanta']].part_limit>trueReqMaruti)
                 {min=trueReqMaruti;}
                else {min=suppliers[name2Addr['Vedanta']].part_limit;}
                total=min*p2;
                if(availability>trueReqMaruti)
                {
                    availability-=trueReqMaruti;
                    for(uint i=0;i<trueReqMaruti;i++)
                    {
                        parts[s_shelf['Vedanta'][index]].owner = name2Addr['Maruti'];
                        m_shelf_body['Maruti'].push(s_shelf['Vedanta'][index]);              
                        s_shelf['Vedanta'].pop();
                        if(index>=1) index--;
                    }
                    manufacturers[name2Addr['Maruti']].body_limit+=trueReqMaruti;
                    final_maruti_alloc=trueReqMaruti;
                }
                else{
                    for(uint i=0;i<availability;i++)
                    {
                        parts[s_shelf['Vedanta'][index]].owner = name2Addr['Maruti'];
                        m_shelf_body['Maruti'].push(s_shelf['Vedanta'][index]);              
                        s_shelf['Vedanta'].pop();
                        if(index>=1) index--;
                    }
                    manufacturers[name2Addr['Maruti']].body_limit+=availability;
                    final_maruti_alloc=availability;
                    availability=0;
                }
            }
            suppliers[name2Addr['Vedanta']].part_limit = availability;
        }
        else{

            min = suppliers[name2Addr['Vedanta']].part_limit>trueReqMaruti?trueReqMaruti:suppliers[name2Addr['Vedanta']].part_limit;
            total=min*p2;
            uint index = s_shelf['Vedanta'].length-1;
            if(availability>trueReqMaruti)
            {
                availability-=trueReqMaruti;
                for(uint i=0;i<trueReqMaruti;i++)
                {
                    parts[s_shelf['Vedanta'][index]].owner = name2Addr['Maruti'];
                    m_shelf_body['Maruti'].push(s_shelf['Vedanta'][index]);              
                    s_shelf['Vedanta'].pop();
                    if(index>=1) index--;
                }
                manufacturers[name2Addr['Maruti']].body_limit+=trueReqMaruti;
                final_maruti_alloc=trueReqMaruti;

            }
            else{
                for(uint i=0;i<availability;i++)
                {
                    parts[s_shelf['Vedanta'][index]].owner = name2Addr['Maruti'];
                    m_shelf_body['Maruti'].push(s_shelf['Vedanta'][index]);              
                    s_shelf['Vedanta'].pop();
                    if(index>=1) index--;
                }
                manufacturers[name2Addr['Maruti']].body_limit+=availability;
                final_maruti_alloc=availability;
                availability=0;
            }
            suppliers[name2Addr['Vedanta']].part_limit = availability;
             if(availability>0)
            {
                min = suppliers[name2Addr['Vedanta']].part_limit>trueReqTata?trueReqTata:suppliers[name2Addr['Vedanta']].part_limit;
                total=min*p1;
                 if(availability>trueReqTata)
                 {
                    availability-=trueReqTata;
                    for(uint i= 0;i<trueReqTata;i++)
                    {
                        parts[s_shelf['Vedanta'][index]].owner = name2Addr['Tata'];
                        m_shelf_body['Tata'].push(s_shelf['Vedanta'][index]);              
                        s_shelf['Vedanta'].pop();
                        if(index>=1) index--;
                    }
                    manufacturers[name2Addr['Tata']].body_limit+=trueReqTata;
                    final_tata_alloc=trueReqTata;
                }
                else{
                    for(uint i=0;i<availability;i++)
                    {
                        parts[s_shelf['Vedanta'][index]].owner = name2Addr['Tata'];
                        m_shelf_body['Tata'].push(s_shelf['Vedanta'][index]);              
                        s_shelf['Vedanta'].pop();
                        if(index>=1) index--;
                    }
                    manufacturers[name2Addr['Tata']].body_limit+=availability;
                    final_tata_alloc=availability;
                    availability=0;
                }
             }
             suppliers[name2Addr['Vedanta']].part_limit = availability;
        }
        
        
        uint final_amount_to_vedanta = final_tata_alloc*p1 + final_maruti_alloc*p2;
        sendmoneytoName(final_amount_to_vedanta* (1 ether), 'Vedanta');
        if(bids['Tata'].quantity-final_tata_alloc > 0)
            sendmoneytoName((bids['Tata'].quantity-final_tata_alloc) * p1 * (1 ether), 'Tata');
        if(bids['Maruti'].quantity-final_maruti_alloc > 0)
            sendmoneytoName((bids['Maruti'].quantity-final_maruti_alloc) * p2 * (1 ether), 'Maruti'); 
    } 
   
    function makeProduct() public isManufacturer
    {
        string memory m_name = manufacturers[msg.sender].name;
        uint noOfCars=manufacturers[msg.sender].tyre_limit>manufacturers[msg.sender].body_limit?manufacturers[msg.sender].body_limit:manufacturers[msg.sender].tyre_limit;
        uint tid;
        uint bid;
       
        for(uint i=0;i<noOfCars;i++)
        {  
            tid=m_shelf_tyre[m_name][m_shelf_tyre[m_name].length-1];
            bid=m_shelf_body[m_name][m_shelf_body[m_name].length-1];
            m_shelf_tyre[m_name].pop();
            m_shelf_body[m_name].pop();
            product_shelf[m_name].push(pid);
            products[pid]=product(pid,m_name,tid,bid,msg.sender);
            pid++;
        }

    }

    function setCarPrice(uint _price) public isManufacturer{
        productPrice[msg.sender]=_price;
    }

    function setPartPrice(uint price) public isSupplier{
        partPrice[msg.sender]=price;
    }

    function getCarPrice(string memory brand) public view returns(string memory){
        return uint2str(productPrice[name2Addr[brand]]);
    }

    function getPartPrice() public view returns(string memory){
        address a = msg.sender;
        string memory name = manufacturers[a].name;
        if(keccak256(abi.encodePacked(name)) == keccak256(abi.encodePacked('Tata')))
            return uint2str(partPrice[name2Addr['MRF']]);
        else return uint2str(partPrice[name2Addr['CEAT']]);
    }


    function purchaseCar(string memory brand) public payable isCustomer{
        uint cid; uint tid; uint bid;
        uint price=productPrice[name2Addr[brand]] * (1 ether);
        uint value = msg.value;
        if(product_shelf[brand].length>0 && value >= price)
            {sendmoneytoName(price, brand);
             if (value-price>0)
                sendmoneytoAdd(value-price, msg.sender);
            
            cid=product_shelf[brand][product_shelf[brand].length-1];
            product_shelf[brand].pop();
            carOwner[msg.sender]=cid;
            products[cid].owner=msg.sender;
            tid=products[cid].tyre_id;
            bid=products[cid].body_id;
            parts[tid].owner=msg.sender;
            parts[bid].owner=msg.sender;
            // return true;
            }
        else {
            sendmoneytoAdd(msg.value, msg.sender);
            // return false;
            }    
        }
    
   
    function getcarID() public view returns(string memory){
        return uint2str(carOwner[msg.sender]);
    }
    
    
    function verify(uint id) public view returns (string[6] memory){
        string[6] memory  response;
        if(products[id].owner==msg.sender){
            response[0]="Car ownership verified successfully";
        }
        else{
            response[0]="Car ownership not verified";
        }
        string memory a=products[id].brand;
        string memory b="Car brand is";
        response[1]=string(abi.encodePacked(b,' ',a));
        uint  tid=products[id].tyre_id;
        uint  bid=products[id].body_id;
        if(parts[tid].owner==msg.sender){
            response[2]="Tyre Ownership verified successfully";
        }
        else{
            response[2]="Tyre Ownership not verified";
        }
        a=parts[tid].brand;
        b="Tyre brand is";
        response[3]=string(abi.encodePacked(b,' ',a));

        if(parts[bid].owner==msg.sender){
            response[4]="Car Body Ownership verified successfully";
        }
        else{
            response[4]="Car body ownership not verified";
        }
        a=parts[bid].brand;
        b="Car body brand is";
        response[5]=string(abi.encodePacked(b,' ',a));
        return response;
    }
    
        function uint2str(
	  uint256 _i
	)
	  internal
	  pure
	  returns (string memory str)
	{
	  if (_i == 0)
	  {
	    return "0";
	  }
	  uint256 j = _i;
	  uint256 length;
	  while (j != 0)
	  {
	    length++;
	    j /= 10;
	  }
	  bytes memory bstr = new bytes(length);
	  uint256 k = length;
	  j = _i;
	  while (j != 0)
	  {
	    bstr[--k] = bytes1(uint8(48 + j % 10));
	    j /= 10;
	  }
	  str = string(bstr);
	}
	
	
    function addressToString(address _addr) public pure returns(string memory) {
    bytes32 value = bytes32(uint256(uint160(_addr)));
    bytes memory alphabet = "0123456789abcdef";

    bytes memory str = new bytes(51);
    str[0] = "0";
    str[1] = "x";
    for (uint i = 0; i < 20; i++) {
        str[2+i*2] = alphabet[uint(uint8(value[i + 12] >> 4))];
        str[3+i*2] = alphabet[uint(uint8(value[i + 12] & 0x0f))];
    }
    return string(str);
}

    function sendmoneytoAdd(uint amount,address payaddr) internal {
        address payable manuf = payable(payaddr);
        uint money;
        money = money + amount ;
        (bool sent,) = manuf.call{value:money}("");
        require(sent, "transaction failed");
        
    }

    function sendmoneytoName(uint amount,string memory brand) internal{
        sendmoneytoAdd(amount, name2Addr[brand]);
    }


}

