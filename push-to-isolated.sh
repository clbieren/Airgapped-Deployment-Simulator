#!/bin/bash
set -e

# Versiyon numarasını parametre olarak al, verilmezse "latest" kullan
VERSION=${1:-latest}
IMAGE_NAME="todo-api"
ISOLATED_IP="192.168.100.2"
ISOLATED_USER="clbieren"

echo "=== 1) Image build ediliyor: $IMAGE_NAME:$VERSION ==="
docker build -t $IMAGE_NAME:$VERSION .

echo "=== 2) Image .tar dosyasina paketleniyor ==="
docker save -o /tmp/$IMAGE_NAME-$VERSION.tar $IMAGE_NAME:$VERSION

echo "=== 3) Izole makineye tasiniyor (SCP, internetsiz yerel ag) ==="
scp /tmp/$IMAGE_NAME-$VERSION.tar $ISOLATED_USER@$ISOLATED_IP:~/incoming/

echo "=== 4) Yerel gecici .tar dosyasi temizleniyor ==="
rm /tmp/$IMAGE_NAME-$VERSION.tar

echo "=== TAMAMLANDI: $IMAGE_NAME:$VERSION izole-vm'e tasindi ==="
echo "Simdi izole-vm'de su komutu calistir: ./deploy.sh $VERSION"
