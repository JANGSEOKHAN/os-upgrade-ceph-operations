# HAProxy 설치 및 운영 설정

HAProxy를 L4/TCP proxy로 구성해 application node로 트래픽을 분산하는 설정 기록입니다.

## 주요 설정

| 항목 | 설명 |
| --- | --- |
| `global.maxconn` | HAProxy 전체 connection 상한 |
| `defaults.mode tcp` | TCP stream 기준 proxy 동작 |
| `timeout connect` | backend 연결 대기 시간 |
| `timeout client/server` | client/backend idle timeout |
| `frontend` | 외부 요청을 받는 bind port |
| `backend` | 실제 application server와 balancing 정책 |
| `option tcp-check` | backend port health check |
| `stats` | 운영 상태 확인용 dashboard |

## 운영 체크

- backend node down 시 트래픽 제외 여부
- stats page에서 session/current connection 확인
- systemd restart 이후 config 정상 로딩 여부
- firewall 정책과 bind port 충돌 여부

## 예시

공개용 예시는 [`examples/haproxy.cfg`](../examples/haproxy.cfg)에 정리했습니다.
