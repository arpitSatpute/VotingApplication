// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

import "../lib/openzeppelin-contracts/contracts/access/Ownable.sol";

contract Voting is Ownable { 

    struct Candidate {
        string name;
        uint voteCount;
    }
    Candidate[] public candidates;
    address contractOwner;
    mapping(address => bool) public voters;

    uint public votingStart;
    uint public votingEnd;

    constructor(string[] memory _candidatesNames) Ownable(msg.sender) {
        contractOwner = msg.sender;
        
        for(uint i=0; i<_candidatesNames.length; i++) {
            candidates.push(Candidate({
                name: _candidatesNames[i],
                voteCount: 0
            }));
        }

    }

    function addCandidates(string[] memory _candidatesNames) public onlyOwner {
        require(votingEnd == 0, "Voting has Started");
        for(uint i=0; i<_candidatesNames.length; i++) {
            candidates.push(Candidate({
                name: _candidatesNames[i],
                voteCount: 0
            }));
        }
    }

    function removeCandidate(uint _index) public onlyOwner {
        require(_index < candidates.length, "Invalid candidate index");
        for (uint i = _index; i < candidates.length - 1; i++) {
            candidates[i] = candidates[i + 1];
        }
        candidates.pop();
    }

    function startVoting(uint _votingDuration) public onlyOwner{
        votingStart = block.timestamp;
        votingEnd = block.timestamp + (_votingDuration * 1 minutes);
    }

    function getCandidates() public view returns (Candidate[] memory) {
        return candidates;
    }

    function vote(uint _candidateIndex) public {
        require(block.timestamp >= votingStart && block.timestamp <= votingEnd, "Voting is not active");
        require(!voters[msg.sender], "You have already voted");
        require(_candidateIndex < candidates.length, "Invalid candidate index");
        candidates[_candidateIndex].voteCount++;
        voters[msg.sender] = true;

    }

    function getRemainingTime() public view returns (uint) {
        if (block.timestamp >= votingEnd) {
            return 0;
        }
        return votingEnd - block.timestamp;
    }



}
