// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract StarsX is ERC1155,Ownable,Pausable{

    using Counters for Counters.Counter;
    using SafeMath for uint256;

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
       require(msg.value == _Amount*Price,"##3");
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
    function SetPrice(uint256 _Price) public onlyOwner returns(bool){
        Price = _Price;
        return true;
    }

    function SetURI(string memory _NewURI) public onlyOwner returns(bool){
         _setURI(_NewURI);
        return true;
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