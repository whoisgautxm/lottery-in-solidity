// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

contract Lottery {
    address public manager;
    address payable[] public players;
    address payable public winner;

    constructor() {
        manager = msg.sender;
    }

    modifier onlyManager() {
        require(msg.sender == manager, "Only the manager can perform this action");
        _;
    }

    modifier hasMinimumPlayers() {
        require(players.length >= 3, "Minimum 3 players required");
        _;
    }

    function participate() external payable {
        require(msg.value == 1 ether, "Please pay 1 ether only");
        players.push(payable(msg.sender));
    }

    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }

    function random() internal view returns (uint256) {
        return uint256(keccak256(abi.encodePacked(blockhash(block.number - 1), block.timestamp, players.length)));
    }

    function pickWinner() public onlyManager hasMinimumPlayers {
        uint256 rand = random();
        uint256 index = rand % players.length;
        winner = players[index];
        winner.transfer(getBalance());
        delete players;
    }
}
