// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SCAudit {
    string public name = "SCAudit Token";
    string public symbol = "SCA";
    uint8 public decimals = 18;
    uint256 public totalSupply = 1000000 * 10 ** uint256(decimals);
    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;
    mapping(address => bool) public isWhitelisted;
    mapping(address => uint256) public auditRewards;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    event SmartContractAudited(address indexed auditor, string contractCode, string auditReport, uint256 auditScore, uint256 reward);
    event Whitelisted(address indexed user);
    event RemovedFromWhitelist(address indexed user);

    uint256 public auditFee = 10 * 10 ** uint256(decimals); // Fee for auditors to audit a contract
    uint256 public rewardMultiplier = 2; // Reward multiplier for auditors

    constructor() {
        balanceOf[msg.sender] = totalSupply;
    }

    modifier onlyWhitelisted() {
        require(isWhitelisted[msg.sender], "You are not whitelisted.");
        _;
    }

    function transfer(address _to, uint256 _value) public returns (bool success) {
        require(balanceOf[msg.sender] >= _value, "Insufficient balance");
        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;
        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    function approve(address _spender, uint256 _value) public returns (bool success) {
        allowance[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        require(_value <= balanceOf[_from], "Insufficient balance");
        require(_value <= allowance[_from][msg.sender], "Allowance exceeded");
        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;
        allowance[_from][msg.sender] -= _value;
        emit Transfer(_from, _to, _value);
        return true;
    }

    function auditSmartContract(string calldata contractCode, string calldata auditReport) external onlyWhitelisted {
        uint256 auditScore = calculateAuditScore(auditReport);
        uint256 reward = auditScore * rewardMultiplier;
        
        // Transfer the audit fee to the contract creator
        require(balanceOf[msg.sender] >= auditFee, "Insufficient balance to pay the audit fee");
        balanceOf[msg.sender] -= auditFee;
        balanceOf[address(this)] += auditFee;

        // Reward the auditor
        balanceOf[msg.sender] += reward;
        auditRewards[msg.sender] += reward;

        emit SmartContractAudited(msg.sender, contractCode, auditReport, auditScore, reward);
    }

    function calculateAuditScore(string memory auditReport) internal pure returns (uint256) {
        // Simplified audit score calculation based on report content (example)
        // For now, just returning a random value
        return uint256(keccak256(abi.encodePacked(auditReport))) % 100;
    }

    function addToWhitelist(address _user) external {
        require(balanceOf[msg.sender] >= auditFee, "Insufficient balance to whitelist");
        balanceOf[msg.sender] -= auditFee;
        balanceOf[address(this)] += auditFee;
        isWhitelisted[_user] = true;
        emit Whitelisted(_user);
    }

    function removeFromWhitelist(address _user) external {
        require(isWhitelisted[_user], "User not whitelisted");
        isWhitelisted[_user] = false;
        emit RemovedFromWhitelist(_user);
    }

    function getAuditReward(address _auditor) external view returns (uint256) {
        return auditRewards[_auditor];
    }

    function withdrawAuditRewards() external {
        uint256 reward = auditRewards[msg.sender];
        require(reward > 0, "No rewards to withdraw");
        auditRewards[msg.sender] = 0;
        balanceOf[msg.sender] += reward;
    }
}
