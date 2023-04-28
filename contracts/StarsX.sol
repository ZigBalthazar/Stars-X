// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract ABXNft is ERC1155,Ownable,Pausable{

    using Counters for Counters.Counter;
    using SafeMath for uint256;

    address constant ABX_ADDRESS = 0x4892F35B4d956B5EA4C878320A11fFF0a50CeC4c; 
    IERC20 ABX = IERC20(ABX_ADDRESS);
    
    uint256 public total_Supply;
    uint256 public Supply;
    uint256 public Price;
    uint256 public ID;
    string public _Name;
    string public _Symbol;
    bool public Mint_State;

    constructor(uint256 _Amount,string memory _name,string memory _symbol) ERC1155(""){
        total_Supply = _Amount;
        ID = 0;
        _pause();
        Mint_State = true;
        _Name = _name;
        _Symbol = _symbol;
    }

    //Public Functions

    function Mint(uint256 _Amount) public payable whenNotPaused returns(bool){
       require(Mint_State,"##0");
       require(_Amount>0,'##1');
       require(_Amount.add(Supply)<=total_Supply,"##2");
       ABX.transferFrom(
            msg.sender,
            address(this),
            (_Amount*Price)
        );
        Supply = Supply.add(_Amount);
       if(Supply == total_Supply){
           Mint_State = false;
       }
       _mint(msg.sender, ID, _Amount, "");
       return true;
    }

    function totalSupply() view public returns(uint256){
        return total_Supply;
    }

    function name() public view returns(string memory){
        return _Name;
    }
    function symbol() public view returns(string memory){
        return _Symbol;
    }
    //Owner Functions
    function SetPrice(uint256 _Price) public onlyOwner{
        Price = _Price;
    }

    function SetURI(string memory _NewURI) public onlyOwner{
         _setURI(_NewURI);
    }

    function SetPause() public onlyOwner returns(bool){
        if(paused())
        {
            _unpause();
        }
        else
        {
            _pause();
        }
        return paused();
    }
        
    function Withdrawal() payable public onlyOwner{
        (bool sent,) = owner().call{value: address(this).balance}("");
        require(sent, "Failed to send Ether");
    }
}