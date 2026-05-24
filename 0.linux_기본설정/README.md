# Linux 기본 설정

Oracle Linux 업그레이드 이후 서버 운영 기준을 맞추기 위한 기본 설정 항목입니다.

## 내부망 패키지 준비

- 외부망에서 필요한 RPM 또는 archive를 먼저 확보합니다.
- 내부망 서버에는 package repository 정책에 맞춰 전달합니다.
- 설치 전 dependency와 checksum을 확인합니다.

## 사용자/권한 설정

- 운영 계정, 배포 계정, 서비스 계정을 역할별로 분리합니다.
- sudo 권한은 필요한 명령 단위로 제한합니다.
- 계정 생성 후 home directory, shell, umask, password policy를 확인합니다.

## Network

- `nmcli` profile로 NIC 설정을 관리합니다.
- IP, gateway, DNS, IPv6 사용 여부를 profile에 명시합니다.
- 재부팅 이후 동일 profile이 올라오는지 확인합니다.

## fstab / mount

- local disk, NFS, CephFS mount path를 분리합니다.
- network mount는 `_netdev` 옵션을 고려합니다.
- `mount -a`와 reboot test로 설정 오류를 확인합니다.

## LVM

- PV/VG/LV 구성 후 filesystem을 생성합니다.
- application data, log, backup path를 논리 볼륨으로 분리합니다.
- 확장 가능성을 고려해 VG free space를 확인합니다.

## SSH

- root login, password authentication, key authentication 정책을 점검합니다.
- 운영 접근 경로를 제한하고 변경 전 설정 파일을 백업합니다.
- SSH 변경 후 별도 세션에서 접속 가능 여부를 확인합니다.

## sysctl

- file descriptor, TCP keepalive, local port range 등 운영 기준값을 확인합니다.
- Kafka, proxy, storage client처럼 connection이 많은 서비스는 OS 기본값만으로 부족할 수 있습니다.
- 적용 후 `sysctl -p`와 service 영향도를 확인합니다.

## SELinux

- 운영 정책에 맞춰 enforcing/permissive 여부를 결정합니다.
- 비활성화가 필요한 경우 보안 정책과 서비스 요구사항을 함께 검토합니다.
