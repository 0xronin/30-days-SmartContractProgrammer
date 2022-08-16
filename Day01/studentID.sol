// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract StudentReportCard {
    address public owner; // owner state variable

    mapping(address => student) reportCard; // mapping address to student struct

    constructor() {
        owner = msg.sender; // sets the contract caller address as owner of contract
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "You cannot register students!");
        _;
    }

    struct student {
        // details of student in report card
        address studentID; // this will be the id of student (the wallet address)
        string name;
        uint mathsMarks;
        uint computerMarks;
        uint scienceMarks;
        uint englishMarks;
        uint totalMarks;
        uint percentage;
        bool isRegistered; // to make sure student cannot be registered twice
    }

    function register(
        address studentID,
        string memory name,
        uint mathsMarks,
        uint computerMarks,
        uint scienceMarks,
        uint englishMarks
    ) public onlyOwner {
        require(
            reportCard[studentID].isRegistered == false,
            "This student is already registered!"
        );

        uint totalMarks;
        uint percentage;

        totalMarks = mathsMarks + computerMarks + scienceMarks + englishMarks;
        percentage = totalMarks / 4;

        reportCard[studentID] = student(
            studentID,
            name,
            mathsMarks,
            computerMarks,
            scienceMarks,
            englishMarks,
            totalMarks,
            percentage,
            true
        );
    }

    function getStudentDetails(address studentID)
        public
        view
        returns (
            address,
            string memory,
            uint,
            uint
        )
    {
        return (
            reportCard[studentID].studentID,
            reportCard[studentID].name,
            reportCard[studentID].totalMarks,
            reportCard[studentID].percentage
        );
    }
}
