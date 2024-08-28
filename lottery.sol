// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Lottery {
    //entities - manager,players and winner
    address public manager;
    address payable[] public players;
    address payable public winner;

    constructor() {
        manager = msg.sender;
    }

    function participate() public payable {
        require(msg.value == 1 ether, "Please pay 1 ether only");
        players.push(payable(msg.sender));
    }

    function getBalance() public view returns (uint256) {
        require(manager == msg.sender, "You are not the manager");
        return address(this).balance;
    }

    function random() internal view returns (uint256) {
        return
            uint256(
                keccak256(
                    abi.encodePacked(
                        blockhash(block.number - 1),
                        block.timestamp,
                        players.length
                    )
                )
            );
    }

    function pickWinner() public {
        require(manager == msg.sender, "You are not the manager");
        require(players.length >= 3, "Players are less than 3");

        uint256 r = random();
        uint256 index = r % players.length;
        winner = players[index];
        winner.transfer(getBalance());
        players = new address payable[](0); //this will intiliaze the players array back to 0
    }
}
