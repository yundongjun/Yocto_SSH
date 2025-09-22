# Yocto

---
Yocto 설명


임베디드 제품(보드)에 호환하는 커스텀 리눅스 OS를 만들기 위해 탄생한 오픈소스 프로젝트

---
Yocto 사용법

폴더 기준
```
tree -L 2
.
└── poky
    ├── LICENSE
    ├── LICENSE.GPL-2.0-only
    ├── LICENSE.MIT
    ├── MAINTAINERS.md
    ├── MEMORIAM
    ├── Makefile
    ├── README.OE-Core.md
    ├── README.hardware.md -> meta-yocto-bsp/README.hardware.md
    ├── README.md -> README.poky.md
    ├── README.poky.md -> meta-poky/README.poky.md
    ├── README.qemu.md
    ├── SECURITY.md
    ├── bitbake
    ├── build
    ├── contrib
    ├── documentation
    ├── meta
    ├── meta-poky
    ├── meta-raspberrypi
    ├── meta-rpilinux
    ├── meta-selftest
    ├── meta-skeleton
    ├── meta-yocto-bsp
    ├── oe-init-build-env
    └── scripts
```

## 1) 레이어 만들고 추가 (경로 정확히)
```
cd ~/yocto/poky
source oe-init-build-env build

# poky 아래에 meta-firstboot 생성
bitbake-layers create-layer ../meta-firstboot

# 빌드에 레이어 추가
bitbake-layers add-layer ../meta-firstboot

# 확인
bitbake-layers show-layers
```

```
~/yocto/poky/meta-firstboot/              ← 레이어 루트
└─ recipes-support/firstboot-ssh/
   ├─ files/
   │  ├─ firstboot-ssh.sh
   │  └─ firstboot-ssh.service           ← 여기에 둔다!
   └─ firstboot-ssh_1.0.bb
```

## 2) `local.conf` 최소 추가 (systemd + SSH + 네트워크)
~/yocto/poky/build/conf/local.conf
```
MACHINE ?= "raspberrypi4"

IMAGE_FSTYPES += "wic.bz2 wic.bmap"

# SSH 서버 + 개발 편의(첫 접속 쉽게)
IMAGE_FEATURES += "ssh-server-openssh"
EXTRA_IMAGE_FEATURES += "debug-tweaks"

# 네트워크 유틸
IMAGE_INSTALL:append = " firstboot-ssh connman connman-client iproute2"

# systemd로 운영 (meta-raspberrypi와 잘 맞음)
DISTRO_FEATURES:append = " systemd pam"
VIRTUAL-RUNTIME_init_manager = "systemd"
VIRTUAL-RUNTIME_initscripts = ""
SYSTEMD_AUTO_ENABLE = "enable"
```

3) 빌드 & 굽기
```
bitbake -c cleansstate core-image-minimal
bitbake core-image-minimal

sudo umount /dev/sdb* 2>/dev/null || true
sudo bmaptool copy tmp/deploy/images/raspberrypi4/core-image-minimal-*.rootfs.wic.bz2 /dev/sdb
```


