# Keepalived 설치 및 VIP Failover 구성

Keepalived를 이용해 active/standby node 간 VIP failover를 구성하는 운영 가이드입니다.

## 주요 설정

| 항목 | 설명 |
| --- | --- |
| `state` | 초기 역할. `MASTER` 또는 `BACKUP` |
| `interface` | VIP를 올릴 NIC |
| `virtual_router_id` | 같은 VRRP 그룹을 식별하는 ID |
| `priority` | MASTER 선출 우선순위 |
| `advert_int` | VRRP advertisement 주기 |
| `authentication` | peer 간 VRRP 인증 |
| `virtual_ipaddress` | 장애 전환 시 active node에 올라오는 VIP |

## 운영 체크

- MASTER node 장애 시 BACKUP node에 VIP가 올라오는지 확인
- 장애 복구 후 preempt 정책에 따른 VIP 이동 확인
- HAProxy/Nginx와 함께 사용할 경우 service dependency 확인
- firewall에서 VRRP protocol 허용 여부 확인

## 예시

공개용 예시는 [`examples/keepalived.conf`](../examples/keepalived.conf)에 정리했습니다.
