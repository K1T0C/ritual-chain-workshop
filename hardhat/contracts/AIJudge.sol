// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract AIJudge {
    struct Submission {
        bytes32 commitment;
        string answer;
        bool isRevealed;
        bool exists;
    }

    // Хранилище: id баунти -> адрес участника -> данные заявки
    mapping(uint256 => mapping(address => Submission)) public submissions;

    // 1. Фиксация хеша (Commit)
    function submitCommitment(uint256 bountyId, bytes32 commitment) external {
        require(!submissions[bountyId][msg.sender].exists, "Already submitted");
        submissions[bountyId][msg.sender] = Submission(commitment, "", false, true);
    }

    // 2. Раскрытие ответа (Reveal)
    function revealAnswer(uint256 bountyId, string calldata answer, bytes32 salt) external {
        Submission storage sub = submissions[bountyId][msg.sender];
        require(sub.exists, "No commitment found");
        require(!sub.isRevealed, "Already revealed");

        // Проверка: пересчитываем хеш из полученных данных и сравниваем с сохраненным
        bytes32 computedHash = keccak256(abi.encodePacked(answer, salt, msg.sender, bountyId));
        require(computedHash == sub.commitment, "Invalid reveal: hash mismatch");

        sub.answer = answer;
        sub.isRevealed = true;
    }

    // Заглушки для интеграции с AI
    function judgeAll(uint256 bountyId, bytes calldata llmInput) external {}
    function finalizeWinner(uint256 bountyId, uint256 winnerIndex) external {}
}