// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title Moon Bitcoin-like Token (MBTC)
 * @notice ERC-20 style token that emulates Bitcoin characteristics:
 *   - Fixed supply of 21,000,000 units
 *   - 8 decimals (like Bitcoin's satoshi precision)
 *   - No minting or owner-only privileges after deployment
 *   - All tokens assigned to deployer at construction
 */
contract MoonBTC {
    string public name = "Moon Bitcoin";
    string public symbol = "MBTC";
    uint8 public decimals = 8; // Bitcoin uses 8 decimals
    uint256 public totalSupply;

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    /**
     * @dev Constructor — mints the entire fixed supply to deployer.
     * @param _totalWholeUnits The human-readable whole-unit supply (e.g. 21000000 for 21 million)
     * Note: _totalWholeUnits will be multiplied by 10**decimals inside constructor.
     */
    constructor(uint256 _totalWholeUnits) {
        // Prevent accidental tiny or massive numbers — require a non-zero whole-unit supply
        require(_totalWholeUnits > 0, "supply must be > 0");

        totalSupply = _totalWholeUnits * (10 ** uint256(decimals));
        balanceOf[msg.sender] = totalSupply;
        emit Transfer(address(0), msg.sender, totalSupply);
    }

    function transfer(address _to, uint256 _value) public returns (bool) {
        require(_to != address(0), "transfer to zero address");
        require(balanceOf[msg.sender] >= _value, "insufficient balance");

        unchecked {
            balanceOf[msg.sender] -= _value;
            balanceOf[_to] += _value;
        }

        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    function approve(address _spender, uint256 _value) public returns (bool) {
        allowance[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
        require(_to != address(0), "transfer to zero address");
        require(balanceOf[_from] >= _value, "insufficient balance");
        require(allowance[_from][msg.sender] >= _value, "allowance exceeded");

        unchecked {
            balanceOf[_from] -= _value;
            balanceOf[_to] += _value;
            allowance[_from][msg.sender] -= _value;
        }

        emit Transfer(_from, _to, _value);
        return true;
    }

    /**
     * @notice Convenience getter: whole units + fractional as a uint with decimals applied
     * @dev For example, to deploy 21,000,000 MBTC, pass 21000000 to constructor.
     */
}
