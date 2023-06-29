// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./IRoleNFT.sol";
import "./StructDeclaration.sol";

contract DAO is Ownable {
    struct Proposal {
        address creator;
        string contentURL;
        uint level;
        bool isRejected;
        bool isPublic;
    }

    IRoleNFT public roleNFT;
    Proposal[] private _proposals;

    mapping(uint256 => bytes32[]) private permissionOfApprove;

    constructor(address _roleNFT) {
        roleNFT = IRoleNFT(_roleNFT);
    }

    modifier onlyAdmin() {
        require(roleNFT.isAdmin(msg.sender), "Restricted to members.");
        _;
    }

    function createProposal(string memory _contentURI, bool _isPublic) public {
        _proposals.push(Proposal(msg.sender, _contentURI, 0, false, _isPublic));
    }

    function approveProposal(uint256 index) external {
        require(
            _proposals[index].isRejected == false,
            "This proposal is rejected"
        );

        Proposal storage _proposal = _proposals[index];
        Identity memory _identity = roleNFT.getIdentity(msg.sender);
        bytes32 _permission = keccak256(
            abi.encodePacked(_identity.department, "_", _identity.role)
        );

        for (uint i = 0; i < permissionOfApprove[_proposal.level].length; i++) {
            if (_permission == permissionOfApprove[_proposal.level][i]) {
                _proposal.level += 1;
                return;
            }
        }
        revert("No permission");
    }

    function rejectProposal(uint256 index) external {
        Proposal storage _proposal = _proposals[index];
        Identity memory _identity = roleNFT.getIdentity(msg.sender);
        bytes32 _permission = keccak256(
            abi.encodePacked(_identity.department, "_", _identity.role)
        );

        for (uint i = 0; i < permissionOfApprove[_proposal.level].length; i++) {
            if (_permission == permissionOfApprove[_proposal.level][i]) {
                _proposal.isRejected = true;
                return;
            }
        }
        revert("No permission");
    }

    function deleteProposal(uint index) public onlyAdmin {
        require(index < _proposals.length, "Invalid Index");
        _proposals[index] = _proposals[_proposals.length - 1];
        _proposals.pop();
    }

    function getAllProposal(
        uint256 start,
        uint256 end
    ) public view returns (Proposal[] memory) {
        require(end <= _proposals.length, "Invalid Index");
        Proposal[] memory proposalSlice = new Proposal[](end - start);
        for (uint256 i = start; i < end; i++) {
            proposalSlice[i] = _proposals[i];
        }
        return proposalSlice;
    }

    function getProposalCount() external view returns (uint256) {
        return _proposals.length;
    }

    function addPermission(
        uint256 _level,
        string memory _role
    ) public onlyAdmin {
        permissionOfApprove[_level].push(keccak256(abi.encodePacked(_role)));
    }

    function deletePermission(uint256 _level, uint index) public onlyAdmin {
        bytes32[] storage _permission = permissionOfApprove[_level];
        require(index < _permission.length, "Invalid Index");
        _permission[index] = _permission[_permission.length - 1];
        _permission.pop();
    }

    function setRoleNFT(address _roleNFT) external onlyAdmin {
        roleNFT = IRoleNFT(_roleNFT);
    }

    function getPermissionsOfLevel(
        uint256 _level
    ) public view returns (bytes32[] memory) {
        return permissionOfApprove[_level];
    }
}
