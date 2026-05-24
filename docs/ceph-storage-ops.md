# Ceph Storage Operations

Ceph 기반 스토리지 운영 작업을 공개 가능한 수준으로 요약한 기록입니다.

## 구성 범위

- monitor, manager, osd 구성
- CephFS mount 및 fstab 등록
- admin keyring, secret file 권한 관리
- dashboard 접근 포트와 계정 정책 확인
- 장애 또는 재기동 이후 cluster health 확인

## 운영 체크포인트

```bash
ceph -s
ceph health detail
ceph osd tree
ceph df
ceph mgr stat
```

## Mount Checklist

- Ceph monitor endpoint 확인
- mount target directory 권한 확인
- secret file 권한을 최소화
- `_netdev` 옵션으로 network dependency 반영
- reboot 이후 mount 유지 여부 확인

## 운영 시 주의점

- keyring, secret file은 public repository에 올리지 않습니다.
- 실제 monitor address, host name, dashboard URL은 문서에서 제거합니다.
- 운영 작업 전후로 `ceph -s`와 application read/write test를 함께 확인합니다.

## 공개용 예시

```text
<monitor-endpoint>:/ <mount-path> ceph name=<client-name>,secretfile=<secret-file>,_netdev 0 0
```
