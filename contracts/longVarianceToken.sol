pragma solidity >=0.6.0;
import "./varianceSwapHandler.sol";
import "./destructable.sol";
import "./IERC20.sol";

contract longVarianceToken is IERC20 {
    uint8 public override decimals = 18;

    string constant public name = "long variance token";

    string constant public symbol = "LVT";

    mapping(address => mapping(address => uint256)) public override allowance;

    address varianceSwapHandlerAddress;

    constructor (address _varianceSwapHandlerAddress) public {
    	varianceSwapHandlerAddress = _varianceSwapHandlerAddress;
    }

    function totalSupply() public view override returns (uint256 supply) {
	    supply = varianceSwapHandler(varianceSwapHandlerAddress).totalSupplyLong();
    }


    function balanceOf(address _owner) public view override returns (uint256 balance) {
    	balance = varianceSwapHandler(varianceSwapHandlerAddress).balanceLong(_owner);
    }


    function transfer(address _to, uint256 _value) public override returns (bool success) {
        varianceSwapHandler(varianceSwapHandlerAddress).transferLongVariance(msg.sender, _to, _value);

        emit Transfer(msg.sender, _to, _value);

        return true;
    }

    function approve(address _spender, uint256 _value) public override returns (bool success) {
        allowance[msg.sender][_spender] = _value;

        emit Approval(msg.sender, _spender, _value);

        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) public override returns (bool success) {
        require(_value <= allowance[_from][msg.sender]);

        varianceSwapHandler(varianceSwapHandlerAddress).transferLongVariance(_from, _to, _value);

        allowance[_from][msg.sender] -= _value;

        emit Transfer(_from, _to, _value);

        return true;
    }

    function destruct(address payable _to) public {
        require(msg.sender == varianceSwapHandlerAddress);
        selfdestruct(_to);
    }

}