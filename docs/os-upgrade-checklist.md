# OS Upgrade Checklist

Oracle Linux 7.9에서 8.10으로 업그레이드하는 흐름을 운영 절차 관점으로 정리한 체크리스트입니다.

## 1. Pre-check

- OS release, kernel, package repository 상태 확인
- CPU, memory, disk, filesystem 사용률 확인
- LVM, mount, fstab, NFS 의존성 확인
- NTP/chrony 동기화 상태 확인
- SSH 접근 정책과 방화벽 정책 백업
- 운영 서비스, systemd unit, cron 목록 정리

## 2. Backup

- `/etc`, application config, service unit 백업
- fstab, network profile, sysctl, sshd config 백업
- rollback 가능 여부와 작업 창구 확인
- 파일 이관이 필요한 경우 rsync dry-run으로 대상 검증

## 3. Upgrade

- package repository 전환 및 의존성 확인
- OS upgrade 수행
- reboot 이후 kernel, repository, package 상태 확인
- 주요 서비스 기동 상태 점검

## 4. Base Configuration

- network profile 재확인
- LVM, filesystem, mount 상태 확인
- NTP/chrony 동기화 확인
- SELinux, firewalld, sysctl 정책 재점검
- SSH 접근 정책과 계정 권한 확인

## 5. Validation

- service health check
- application endpoint check
- storage mount read/write test
- backup job and log path check
- monitoring metric 수집 여부 확인

## 설정값 확인 관점

- `fstab`: boot 시 자동 mount가 필요한 filesystem인지, 네트워크 mount라면 `_netdev`가 필요한지 확인합니다.
- `sysctl.conf`: connection 수, network buffer, file descriptor 기준이 서비스 특성에 맞는지 확인합니다.
- `sshd_config`: 접근 정책, key 인증, root login 정책이 운영 기준에 맞는지 확인합니다.
- `chrony.conf`: 기준 시간 서버와 sync 상태를 확인해 로그 추적 기준을 맞춥니다.
- `nmcli profile`: NIC 이름, IP, gateway, DNS가 재부팅 이후에도 유지되는지 확인합니다.
