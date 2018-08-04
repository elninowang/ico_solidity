pragma solidity ^0.4.21;
import './SafeMath.sol';

/*ERC20 token 标准*/
contract ERC20  {
  function totalSupply() constant returns (uint);
  function balanceOf(address owner) public constant returns (uint256);
  function transfer(address to, uint256 value) public returns (bool);
  function transferFrom(address from, address to, uint256 value) public returns (bool);
  function approve(address spender, uint256 value) public returns (bool);
  function allowance(address owner, address spender) public constant returns (uint256);

  event Transfer(address indexed from, address indexed to, uint256 value);
  event Approval(address indexed owner, address indexed spender, uint256 value);
}

/*基于ERC20标准的代币合约*/
contract DappToken is ERC20, SafeMath{
    string  public  constant name = "DApp Token";
    string  public constant symbol = "DAPP";
    string  public constant version = "DApp Token v1.0";
    uint8 public decimals = 18;

    address  public _tokenIssuer=msg.sender;
    uint256  public _totalSupply;

    event Transfer(address indexed _from,address indexed _to,uint256 _value );
    event Approval( address indexed _owner, address indexed _spender, uint256 _value);
    mapping(address => uint256) public _balanceOf;
    mapping(address => mapping(address => uint256)) public _allowance;

    function DappToken (uint256 _initialSupply) public {
        _totalSupply = _initialSupply;
        _balanceOf[_tokenIssuer] = _initialSupply;
    }

    function totalSupply() constant returns (uint){
        return _totalSupply;
     }

    function balanceOf(address _owner) public constant returns (uint256 balance) {
        return _balanceOf[_owner];
    }

    function transfer(address _to, uint256 _value) public returns (bool success) {
        require(_balanceOf[_tokenIssuer] >= _value);

        //_balanceOf[_tokenIssuer] -= _value;
        _balanceOf[_tokenIssuer]= sub(_balanceOf[_tokenIssuer],_value);
        // _balanceOf[_to] += _value;
        _balanceOf[_to]=add(_balanceOf[_to],_value);

        Transfer(_tokenIssuer, _to, _value);

        return true;

    }

    function approve(address _spender, uint256 _value) public returns (bool success) {
        _allowance[_tokenIssuer][_spender] = _value;

        Approval(_tokenIssuer, _spender, _value);

        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        require(_value <= _balanceOf[_from]);
        require(_value <= _allowance[_from][_tokenIssuer]);

        //_balanceOf[_from] -= _value;
        _balanceOf[_from] = sub(_balanceOf[_from],_value);
        //_balanceOf[_to] += _value;
        _balanceOf[_to] = add(_balanceOf[_to],_value);

        //_allowance[_from][_tokenIssuer] -= _value;
        _allowance[_from][_tokenIssuer] = sub(_allowance[_from][_tokenIssuer],_value);
        Transfer(_from, _to, _value);

        return true;
    }

    function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
         return _allowance[_owner][_spender];
    }

    function getTokenIssuer() public view returns(address) {
         return _tokenIssuer;
    }

    function endOfTokensale() public constant {
        _balanceOf[_tokenIssuer]=0;
    }
}
