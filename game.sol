// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract RockPaperScissors {
    enum Move { None, Rock, Paper, Scissors }
    enum Result { None, Win, Lose, Draw }

    struct Game {
        address player;
        Move playerMove;
        Move randomMove;
        uint256 amount;
        Result result;
    }

    mapping(address => Game[]) public gameHistory;

    event GameResult(address indexed player, Move playerMove, Move randomMove, uint256 amount, Result result);

    function play(Move _playerMove) external payable {
        require(msg.value == 0.0001 ether, "Please send 0.0001 tBNB to play");
        Move randomMove = Move(random(msg.sender, block.timestamp) % 3 + 1);
        Result result = getResult(_playerMove, randomMove);
        uint256 reward = 0;

        if (result == Result.Win) {
            reward = msg.value * 2;
            payable(msg.sender).transfer(reward);
        }

        gameHistory[msg.sender].push(Game(msg.sender, _playerMove, randomMove, msg.value, result));
        emit GameResult(msg.sender, _playerMove, randomMove, msg.value, result);
    }

    function getResult(Move _playerMove, Move _randomMove) internal pure returns (Result) {
        if ((_playerMove == Move.Rock && _randomMove == Move.Scissors) ||
            (_playerMove == Move.Paper && _randomMove == Move.Rock) ||
            (_playerMove == Move.Scissors && _randomMove == Move.Paper)) {
            return Result.Win;
        } else if (_playerMove == _randomMove) {
            return Result.Draw;
        } else {
            return Result.Lose;
        }
    }

    function random(address sender, uint256 seed) private view returns (uint256) {
        return uint256(keccak256(abi.encodePacked(block.difficulty, block.timestamp, sender, seed)));
    }
}
