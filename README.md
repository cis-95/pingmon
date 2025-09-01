## 1. ดาวน์โหลด repo
```
git clone https://github.com/cis-95/pingmon.git
```
```
cd pingmon
```

## 2. ติดตั้ง script ไปที่ /usr/local/bin
```
sudo install -m 755 pingmon.sh /usr/local/bin/pingmon
```

## 3. สร้างโฟลเดอร์ config + log
```
sudo mkdir -p /etc/pingmon /var/log/pingmon
```

## 4. วาง config และ targets (ถ้าไม่มีจะใช้ของ sample)
```
sudo cp config.env /etc/pingmon/config.env
```
```
sudo cp targets.txt /etc/pingmon/targets.txt
```

## 5. ทดสอบ Run
```
pingmon -c /etc/pingmon/config.env
```

## 6. ตั้งค่า Cron/Timer
```
sudo crontab -e
```
ตัวอย่าง cron ทุก 5 นาที:
```
*/5 * * * * /usr/local/bin/pingmon -c /etc/pingmon/config.env >/dev/null 2>&1
```
