pragma solidity ^0.5.10;

contract UsdtInterface {
    /**
    * @dev transfer token for a specified address
    * @param _to The address to transfer to.
    * @param _value The amount to be transferred.
    */
    function transfer(address _to, uint _value) public;
    /**
    * @dev Transfer tokens from one address to another
    * @param _from address The address which you want to send tokens from
    * @param _to address The address which you want to transfer to
    * @param _value uint256 the amount of tokens to be transferred
    */
    function transferFrom(address _from, address _to, uint _value) public;
}

contract GctInterface {
    /**
    * @dev transfer token for a specified address
    * @param _to The address to transfer to.
    * @param _value The amount to be transferred.
    */
    function transfer(address _to, uint256 _value) public returns (bool success);
    /**
    * @dev Transfer tokens from one address to another
    * @param _from address The address which you want to send tokens from
    * @param _to address The address which you want to transfer to
    * @param _value uint256 the amount of tokens to be transferred
    */
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
}

/**
 * @title SafeMath
 * @dev Math operations with safety checks that throw on error
 */
library SafeMath {

  /**
  * @dev Multiplies two numbers, throws on overflow.
  */
  function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
    // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
    // benefit is lost if 'b' is also tested.
    // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
    if (a == 0) {
      return 0;
    }
    c = a * b;
    assert(c / a == b);
    return c;
  }

  /**
  * @dev Integer division of two numbers, truncating the quotient.
  */
  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    // assert(b > 0); // Solidity automatically throws when dividing by 0
    // uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold
    return a / b;
  }

  /**
  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
  */
  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    assert(b <= a);
    return a - b;
  }

  /**
  * @dev Adds two numbers, throws on overflow.
  */
  function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
    c = a + b;
    assert(c >= a);
    return c;
  }
}


contract BasicContract {

    using SafeMath for uint256;
    
    modifier needGeMinInAmount(uint256 amount)
    {
        require(amount >= 100000000,"At least 100 USDT");
        _;
    }

    modifier needMaxInAmount(uint256 amount) {
        if(globalAmount <= pow6().mul(500)) {
            require(amount <= pow6().mul(30),"At most 30 USDT");
        } else {
            require(amount <= pow6().mul(100),"At most 10000 USDT");
        }
        _;
    }

    function mine(uint256 usdtAmount)
        internal
    {
        Account storage account = accounts[msg.sender];
        account.times += 1;
        if(account.times <= 2) {
            return;
        }
        uint256 baseNum = 100000000000000;
        uint256 rate = 0;
        if(globalAmount <= baseNum) {
            rate = 7 * 200;
        } else {
            rate = 7 * 100;
        }
        uint256 gct = (usdtAmount.mul(rate)).div(1000);
        freeGct = freeGct.add(gct);
        require(GcToken.transferFrom(msg.sender,address(this),gct),"transfer failed");
    }

    function remainNodes()
        public
        view
        returns(uint8,uint8,uint8)
    {
        return (remainLargeNodeNum,remainMiddleNodeNum,remainTinyNodeNum);
    }

    function getNodNumber()
        public
        view
        returns(uint256)
    {
        return noders.length;
    }

    function getNod(uint32 index)
        public
        view
        returns(uint8,uint8,uint256,address,uint256)
    {
        address noder = noderList[index];
        uint256 number = nodeNumber[index];
        Node memory node = nodes[noder];
        return (node.st,node.le,node.day,noder,number);
    }

    function getAddressList(
        uint256 day
    )
        public
        view
        returns(address[] memory)
    {
        return invitorList[day];
    } 

    function getEligibleList(
        uint256 day
    )
        public
        view
        returns(address[] memory)
    {
        return eligibleList[day];
    }

    function getEligibleDay(
        address user
    )
        public
        view
        returns(uint256[] memory)
    {
        return eligibleDay[user];
    }
    
    function getAmtOnOneDay(
        address user,
        uint256 day
    )
        public
        view
        returns(uint256,uint256)
    {
        Asset storage asset = assets[user];
        uint256 invNew = asset.newAmt[day];
        uint256 invConti = asset.renewAmt[day];
        return (invNew,invConti);
    }
}

