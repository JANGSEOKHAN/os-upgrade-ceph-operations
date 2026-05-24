# Nginx 설치 및 운영 설정

Nginx를 reverse proxy 또는 static file serving 용도로 구성할 때 확인한 운영 항목입니다.

## 주요 설정

- `server_name`: 요청 host routing 기준
- `listen`: service port
- `location`: upstream 또는 static path 매핑
- `proxy_set_header`: backend 전달 header
- `client_max_body_size`: upload size 제한
- `access_log`, `error_log`: 로그 경로와 rotation 정책

## 운영 체크

- `nginx -t`로 syntax 검증
- reload와 restart 영향도 구분
- upstream 장애 시 timeout 정책 확인
- log path 권한과 disk 사용량 확인
- TLS 적용 시 certificate 만료일 확인

## 적용 흐름

1. config 작성
2. `nginx -t`
3. reload
4. endpoint health check
5. access/error log 확인
