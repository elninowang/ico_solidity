pragma solidity ^0.4.21;

import "./DappToken.sol";
import './SafeMath.sol';

/*代币销售合约*/
contract DappTokenSale is SafeMath{
    address crowdsaleManager;
    DappToken public tokenContract;
    uint256 public tokenPrice;
    uint256 public tokensSold;

    event Sell(address _buyer, uint256 _amount);

      /*发售代币，设定发行价*/
    function DappTokenSale(DappToken _tokenContract, uint256 _tokenPrice) public{
        require(_tokenContract != address(0x0));
        crowdsaleManager = msg.sender;
        tokenContract = DappToken(_tokenContract);
        tokenPrice = _tokenPrice;
    }

    /*购买代币，支付ETH*/
    function buyTokens(uint256 _numberOfTokens) public payable{

       require(msg.value == mul(_numberOfTokens, tokenPrice));
       require(tokenContract.balanceOf(tokenContract.getTokenIssuer()) >= _numberOfTokens);
       require(tokenContract.transfer(msg.sender, _numberOfTokens));
       //tokensSold += _numberOfTokens;
       tokensSold=add(tokensSold,_numberOfTokens);
       Sell(msg.sender, _numberOfTokens);
    }

    /*ICO结束*/
    function endSale() public {

        require(msg.sender == crowdsaleManager);
        require(tokenContract.transfer(crowdsaleManager, tokenContract.balanceOf(tokenContract.getTokenIssuer())));
        tokenContract.endOfTokensale();
        selfdestruct(crowdsaleManager);
    }
}
