// SPDX-License-Identifier: MIT
pragma solidity ^0.8.1;

import "./ERC4907.sol";

// We are extending our contract from ERC4907. It lets us make our NFTs rentable and gives us access to functions like setUser and userOf.
contract RentableNFT is ERC4907 {
    mapping(uint256 => string) public tokenURIs;

    // We are accepting the collection's name and its symbol in our constructor. 1:1 copy of how it's done in an ERC721 contract.
    constructor(string memory _name, string memory _symbol)
        ERC4907(_name, _symbol)
    {}

    function mint(uint256 _tokenId, string memory _tokenURI) public {
        _mint(msg.sender, _tokenId);
        tokenURIs[_tokenId] = _tokenURI;
    }

    // This is where the ✨ magic ✨ happens. This function will let any owners rent out their NFTs.
    // It internally calls the setUser function from the ERC4907 standard
    function rentOut(
        uint256 _tokenId,
        address _user,
        uint64 _expires
    ) public onlyOwner(_tokenId) {
        setUser(_tokenId, _user, _expires);
    }

    // Returns the tokenURI for a given _tokenId
    function tokenURI(uint256 _tokenId)
        public
        view
        override
        returns (string memory)
    {
        return tokenURIs[_tokenId];
    }

    // Checks if the account calling the function actually owns the given token.
    modifier onlyOwner(uint256 _tokenId) {
        require(
            _isApprovedOrOwner(msg.sender, _tokenId),
            "caller is not owner nor approved"
        );
        _;
    }
}
