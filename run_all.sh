#!/bin/bash

echo "🎉 WriteWise MVP 전체 실행 스크립트"
echo "=================================="

# 스크립트 실행 권한 부여
chmod +x run_backend.sh
chmod +x run_frontend.sh

echo ""
echo "📋 실행 순서:"
echo "1. 백엔드 서버 시작 (포트 8000)"
echo "2. 프론트엔드 서버 시작 (포트 3000)"
echo ""
echo "⚠️  주의사항:"
echo "- 백엔드가 완전히 시작된 후 프론트엔드가 시작됩니다"
echo "- 첫 실행 시 모델 다운로드로 시간이 걸릴 수 있습니다"
echo "- GPU가 있다면 자동으로 사용됩니다"
echo ""

# 백엔드 시작 (백그라운드)
echo "🚀 백엔드 서버 시작 중..."
./run_backend.sh &
BACKEND_PID=$!

# 백엔드 시작 대기
echo "⏳ 백엔드 서버 시작 대기 중..."
sleep 10

# 백엔드 상태 확인
echo "🔍 백엔드 서버 상태 확인 중..."
if curl -s http://localhost:8000/health > /dev/null; then
    echo "✅ 백엔드 서버가 정상적으로 시작되었습니다"
else
    echo "❌ 백엔드 서버 시작에 실패했습니다"
    echo "백엔드 로그를 확인해주세요"
    kill $BACKEND_PID 2>/dev/null
    exit 1
fi

# 프론트엔드 시작
echo ""
echo "🚀 프론트엔드 서버 시작 중..."
./run_frontend.sh &
FRONTEND_PID=$!

echo ""
echo "🎉 WriteWise MVP가 성공적으로 시작되었습니다!"
echo ""
echo "📱 접속 주소:"
echo "- 프론트엔드: http://localhost:3000"
echo "- 백엔드 API: http://localhost:8000"
echo "- API 문서: http://localhost:8000/docs"
echo ""
echo "🛑 종료하려면 Ctrl+C를 누르세요"

# 종료 처리
trap 'echo ""; echo "🛑 서버 종료 중..."; kill $BACKEND_PID $FRONTEND_PID 2>/dev/null; exit 0' INT

# 대기
wait 