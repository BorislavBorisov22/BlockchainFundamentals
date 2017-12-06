pragma solidity ^0.4.15;


contract Voting {
    mapping (bytes32 => uint8) public votesRecieved;

    bytes32[] public candidateList;

    function Voting(bytes32[] candidateNames) {
        candidateList = candidateNames;
    }

    function totalVotesFor(bytes32 candidate) view public returns (uint8) {
        require(validateCandidate(candidate));
        return votesRecieved[candidate];
    }

    function voteForCandidate(bytes32 candidate) {
        require(validateCandidate(candidate));
        votesRecieved[candidate] += 1;
    }

    function validateCandidate(bytes32 candidate) view public returns (bool) {
        for (uint i = 0; i < candidateList.length; i++) {
            if (candidateList[i] == candidate ) {
                return true;
            }
        }

        return false;
    }
}

