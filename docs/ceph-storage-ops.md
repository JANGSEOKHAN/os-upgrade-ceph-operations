# Ceph 스토리지 구축 및 운영 기록

Ceph 기반 스토리지 구축과 운영에서 확인해야 하는 구성값, daemon 역할, mount 절차, 점검 명령을 정리한 기록입니다.

## 구성 범위

- monitor, manager, osd 구성
- MDS 구성과 CephFS metadata/data pool 생성
- CephFS mount 및 fstab 등록
- admin keyring, secret file 권한 관리
- dashboard 접근 포트와 계정 정책 확인
- 장애 또는 재기동 이후 cluster health 확인

## 구축 흐름

1. Ceph package를 설치하고 `/etc/hosts` 또는 DNS 기준으로 monitor node를 식별합니다.
2. `ceph.conf`에 cluster fsid, monitor endpoint, public network, cephx 인증 정책을 정의합니다.
3. MON/Admin/bootstrap-osd keyring을 생성하고 monitor keyring에 병합합니다.
4. `monmaptool`로 monmap을 만들고 첫 monitor를 `ceph-mon --mkfs`로 초기화합니다.
5. manager daemon을 등록하고 dashboard/metric 기능을 사용할 수 있는 상태로 만듭니다.
6. MDS daemon을 구성한 뒤 CephFS metadata/data pool을 생성합니다.
7. OSD를 추가해 실제 object 저장 계층을 구성하고 replication size를 조정합니다.
8. application server에서 CephFS를 mount하고 `/etc/fstab`에 `_netdev`, `secretfile` 옵션을 반영합니다.
9. 추가 node를 확장할 때 MON, MDS, MGR, OSD 순서로 역할을 분리해 붙이고 quorum과 OSD tree를 확인합니다.

## 운영 체크포인트

```bash
ceph -s
ceph health detail
ceph osd tree
ceph df
ceph mgr stat
```

## 주요 설정값

| Setting | Description |
| --- | --- |
| `mon_host` | Ceph client가 접근할 monitor endpoint 목록입니다. monitor quorum 장애를 고려해 복수 endpoint를 지정합니다. |
| `public_network` | client, monitor, OSD 통신이 이루어지는 network CIDR입니다. |
| `auth_cluster_required` | cluster 내부 인증 방식입니다. 일반적으로 `cephx`를 사용합니다. |
| `auth_service_required` | service daemon과 client 사이 인증 방식입니다. |
| `auth_client_required` | client 접근 인증 방식입니다. |
| `log.dirs` | daemon log와 data path가 분리되어 있는지 확인합니다. |
| `secretfile` | CephFS mount에 사용하는 client secret file 경로입니다. file permission을 제한합니다. |
| `_netdev` | 네트워크 준비 이후 mount되도록 부팅 순서를 보정하는 fstab option입니다. |

## Mount Checklist

- Ceph monitor endpoint 확인
- mount target directory 권한 확인
- secret file 권한을 최소화
- `_netdev` 옵션으로 network dependency 반영
- reboot 이후 mount 유지 여부 확인

## 장애 확인 관점

- `HEALTH_WARN`, `HEALTH_ERR` 발생 여부
- down/out 상태의 OSD 존재 여부
- manager active/standby 상태
- CephFS mount read/write 가능 여부
- application server에서 mount path 접근 가능 여부

## fstab 예시

```text
<monitor-endpoint>:/ <mount-path> ceph name=<client-name>,secretfile=<secret-file>,_netdev 0 0
```

## 관련 작업 기록

- [`5.ceph_설정/ceph_설정`](../5.ceph_%EC%84%A4%EC%A0%95/ceph_%EC%84%A4%EC%A0%95): Ceph package 설치, MON/MGR/MDS/OSD 구성, CephFS mount, dashboard, 추가 node 확장 작업 기록
- [`0.linux_기본설정/fstab_설정`](../0.linux_%EA%B8%B0%EB%B3%B8%EC%84%A4%EC%A0%95/fstab_%EC%84%A4%EC%A0%95): CephFS/NFS 등 network filesystem mount 기준 기록
