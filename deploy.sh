set -e 

VERSION=${1:-latest}
IMAGE_NAME="todo-api"
CONTAINER_NAME="todo-container-prod"
REGISTRY="localhost:5000"

echo "=== 1) Gelen .tar dosyasi yukleniyor ==="
docker load -i $HOME/incoming/$IMAGE_NAME-$VERSION.tar

echo "=== 2)kendi registry icin yeniden etiketleniyor ==="
docker tag $IMAGE_NAME:$VERSION $REGISTRY/$IMAGE_NAME:$VERSION

echo "=== 3) Kendi private registry'e push ediliyor ==="
docker push $REGISTRY/$IMAGE_NAME:$VERSION

echo "=== 4) Eski container durduruluyor ==="
docker stop $CONTAINER_NAME 2>/dev/null || true
docker rm $CONTAINER_NAME 2>/dev/null || true

echo "=== 5) yeni versiyon calistiriliyor ==="
docker run -d -p 8000:8000 --name $CONTAINER_NAME --restart=always $REGISTRY/$IMAGE_NAME:$VERSION

echo "=== 6) Gecici .tar dosyasi temizleniyor ==="
rm $HOME/incoming/$IMAGE_NAME-$VERSION.tar

echo "=== TAMAMLANDI: $IMAGE_NAME:$VERSION artik canlida ==="
sleep 2
curl -s http://localhost:8000/
echo ""
