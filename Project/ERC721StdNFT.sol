// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// ERC165 인터페이스
interface ERC165 {
    function supportsInterface(bytes4 interfaceID) external view returns (bool);
}

// ERC721 인터페이스
interface ERC721 is ERC165 {
    event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId); // 전송 이벤트
    event Approval(address indexed _owner, address indexed _approved, uint256 indexed _tokenId); // 승인 이벤트
    event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved); // 모든 토큰에 대한 승인 이벤트

    function balanceOf(address _owner) external view returns (uint256); // 소유자의 NFT 개수 조회
    function ownerOf(uint256 _tokenId) external view returns (address); // 특정 토큰의 소유자 조회
    function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes calldata data) external payable; // 안전한 전송
    function safeTransferFrom(address _from, address _to, uint256 _tokenId) external payable; // 안전한 전송 (데이터 없음)
    function transferFrom(address _from, address _to, uint256 _tokenId) external payable; // 토큰 전송
    function approve(address _approved, uint256 _tokenId) external; // 특정 주소에 대한 승인
    function setApprovalForAll(address _operator, bool _approved) external; // 모든 토큰에 대한 운영자 승인 설정
    function getApproved(uint256 _tokenId) external view returns (address); // 특정 토큰에 대한 승인된 주소 조회
    function isApprovedForAll(address _owner, address _operator) external view returns (bool); // 모든 토큰에 대한 운영자 승인 여부 조회
}

// ERC721TokenReceiver 인터페이스
interface ERC721TokenReceiver {
    function onERC721Received(address _operator, address _from, uint256 _tokenId, bytes calldata _data) external returns (bytes4); // 안전한 전송을 위한 콜백 함수
}

// ERC721 표준 NFT 계약
contract ERC721StdNFT is ERC721 {
    address public founder; // 창립자 주소
    mapping(uint256 => address) internal _ownerOf; // 각 NFT의 소유자 주소 매핑
    mapping(address => uint256) internal _balanceOf; // 특정 주소가 보유한 NFT의 개수 매핑
    mapping(uint256 => address) internal _approvals; // 특정 NFT를 대신 전송할 권리를 부여받은 주소 매핑
    mapping(address => mapping(address => bool)) public _operatorApprovals; // 특정 주소가 소유자의 모든 NFT를 관리할 권한 여부 매핑
    string public name; // NFT 이름
    string public symbol; // NFT 심볼

    // 생성자
    constructor(string memory _name, string memory _symbol) {
        founder = msg.sender; // 창립자 주소 설정
        name = _name; // NFT 이름 설정
        symbol = _symbol; // NFT 심볼 설정

        // 초기 5개의 NFT 발행
        for (uint256 tokenID = 1; tokenID <= 5; tokenID++) {
            _mint(msg.sender, tokenID); // 창립자에게 NFT 발행
        }
    }

    // 내부 함수: 새 토큰을 발행하기 위한 함수
    function _mint(address to, uint256 tokenId) internal {
        require(to != address(0), "mint to zero address"); // 0 주소로 발행할 수 없음
        require(_ownerOf[tokenId] == address(0), "already minted"); // 이미 발행된 토큰인지 확인

        _balanceOf[to] += 1; // 소유자의 NFT 개수 증가
        _ownerOf[tokenId] = to; // NFT 소유자 설정
        emit Transfer(address(0), to, tokenId); // Transfer 이벤트 발생
    }

    // 새 NFT 발행
    function mintNFT(address to, uint256 tokenId) public {
        require(msg.sender == founder, "not an authorized minter"); // 창립자만 호출 가능
        _mint(to, tokenId); // NFT 발행
    }

    // 소유자 확인
    function ownerOf(uint256 _tokenId) external view override returns (address) {
        address owner = _ownerOf[_tokenId]; // 토큰 소유자 조회
        require(owner != address(0), "token doesn't exist"); // 토큰이 존재하는지 확인
        return owner; // 소유자 반환
    }

    // 잔액 확인
    function balanceOf(address _owner) external view override returns (uint256) {
        require(_owner != address(0), "balance query for the zero address"); // 0 주소에 대한 잔액 조회 불가
        return _balanceOf[_owner]; // 소유자의 NFT 개수 반환
    }

    // 승인된 주소 확인
    function getApproved(uint256 _tokenId) external view override returns (address) {
        require(_ownerOf[_tokenId] != address(0), "token doesn't exist"); // 토큰이 존재하는지 확인
        return _approvals[_tokenId]; // 승인된 주소 반환
    }

    // 모든 NFT에 대한 운영자 승인 확인
    function isApprovedForAll(address _owner, address _operator) external view override returns (bool) {
        return _operatorApprovals[_owner][_operator]; // 운영자 승인 여부 반환
    }

    // 특정 NFT의 전송을 다른 주소에게 허가
    function approve(address _approved, uint256 _tokenId) external override {
        address owner = _ownerOf[_tokenId]; // 토큰 소유자 조회
        require(msg.sender == owner || _operatorApprovals[owner][msg.sender], "not authorized"); // 권한 확인
        _approvals[_tokenId] = _approved; // 승인된 주소 설정
        emit Approval(owner, _approved, _tokenId); // Approval 이벤트 발생
    }

    // 주어진 운영자의 승인을 설정 또는 해제
    function setApprovalForAll(address _operator, bool _approved) external override {
        _operatorApprovals[msg.sender][_operator] = _approved; // 운영자 승인 설정
        emit ApprovalForAll(msg.sender, _operator, _approved); // ApprovalForAll 이벤트 발생
    }

    // 주어진 토큰 ID의 소유권을 다른 주소로 전송
    function transferFrom(address from, address to, uint256 tokenId) external override payable {
        _transferFrom(from, to, tokenId); // 내부 전송 함수 호출
    }

    // 내부 함수: 소유권 전송
    function _transferFrom(address _from, address _to, uint256 _tokenId) private {
        address owner = _ownerOf[_tokenId]; // 토큰 소유자 조회
        require(_from == owner, "from != owner"); // 발신자가 소유자인지 확인
        require(_to != address(0), "transfer to zero address"); // 0 주소로 전송 불가
        require(msg.sender == owner || msg.sender == _approvals[_tokenId] || _operatorApprovals[owner][msg.sender], "not authorized"); // 권한 확인

        _balanceOf[_from] -= 1; // 발신자의 NFT 개수 감소
        _balanceOf[_to] += 1; // 수신자의 NFT 개수 증가
        _ownerOf[_tokenId] = _to; // 새로운 소유자 설정
        delete _approvals[_tokenId]; // 승인 삭제
        emit Transfer(_from, _to, _tokenId); // Transfer 이벤트 발생
    }

    // 주어진 토큰 ID의 소유권을 다른 주소로 안전하게 전송
    function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes calldata data) external override payable {
        _transferFrom(_from, _to, _tokenId); // 전송 함수 호출
        require(
            _to.code.length == 0 || 
            ERC721TokenReceiver(_to).onERC721Received(msg.sender, _from, _tokenId, data) == ERC721TokenReceiver.onERC721Received.selector,
            "unsafe recipient" // 안전하지 않은 수신자 확인
        );
    }

    // 주어진 토큰 ID의 소유권을 다른 주소로 안전하게 전송
    function safeTransferFrom(address _from, address _to, uint256 _tokenId) external override payable {
        _transferFrom(_from, _to, _tokenId); // 전송 함수 호출
        require(
            _to.code.length == 0 || 
            ERC721TokenReceiver(_to).onERC721Received(msg.sender, _from, _tokenId,"") == ERC721TokenReceiver.onERC721Received.selector,
            "unsafe recipient" // 안전하지 않은 수신자 확인
        );
    }

    // ERC-165 구현
    function supportsInterface(bytes4 interfaceId) external pure override returns (bool) {
        return interfaceId == type(ERC721).interfaceId || interfaceId == type(ERC165).interfaceId; // 지원하는 인터페이스 확인
    }
}