# OS Upgrade & Ceph Storage Operations

Oracle Linux 기반 서버 업그레이드와 Ceph 스토리지 운영 과정에서 정리한 공개용 작업 기록입니다.

이 저장소는 실제 운영 환경의 내부 정보가 아닌, 포트폴리오 공개를 위해 재구성한 sanitized 문서와 예시 설정만 포함합니다.

## Scope

- Oracle Linux 7.9에서 8.10으로 업그레이드할 때 확인한 기본 점검 항목
- LVM, NFS, NTP, SSH, sysctl 등 Linux 운영 기본 설정 체크리스트
- HAProxy, Nginx, Keepalived 기반 프록시/가용성 구성 예시
- Ceph mon, mgr, osd 구성과 mount, 운영 점검 흐름
- 파일 백업 및 이관 시 확인해야 할 운영 관점 체크포인트

## Repository Structure

```text
docs/
  os-upgrade-checklist.md
  ceph-storage-ops.md
examples/
  haproxy.cfg
  keepalived.conf
  network-nmcli.sh
```

## Privacy Notice

다음 항목은 공개 저장소에 포함하지 않았습니다.

- 실제 서버명, 내부 IP, 도메인, 계정명
- 비밀번호, keyring, secret, token
- 고객사 내부 구성값과 보안 정책 상세값
- 운영 로그 원문과 장애 상세 정보

## Notes

실제 운영 환경에 적용하기 전에는 OS 버전, 패키지 정책, 네트워크 구조, 스토리지 구성, 보안 기준에 맞춰 별도 검증이 필요합니다.
