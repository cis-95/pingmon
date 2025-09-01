# 🛰️ PingMon

**PingMon** เป็น Shell Script สำหรับ **ตรวจสอบการเชื่อมต่อ (ping) ของ VM/IP หลาย ๆ ตัว**  
เขียน Log แยกตาม IP และจัดการเก็บรักษา Log (Retention) อัตโนมัติตามวันที่กำหนด (ค่าเริ่มต้น 7 วัน)

> ใช้งานง่ายผ่าน `crontab` เหมาะสำหรับ Monitor การ Ping ถึงกันระหว่าง VM ใน Layer 2

---

## ✨ Features
- ✅ อ่านรายการ IP จากไฟล์ (บรรทัดละ 1 IP, รองรับคอมเมนต์ `#`)
- ✅ Ping ตามรอบเวลาที่ตั้งใน `crontab`
- ✅ เขียน Log แยกตาม **IP / วัน**
- ✅ เก็บ Log แบบ Retention (ค่าเริ่มต้น 7 วัน ปรับได้ใน `config.env`)
- ✅ โครงสร้าง Log แบบ **CSV-friendly**  

## 📦 การติดตั้ง

### 1. ดาวน์โหลด repo
```
git clone https://github.com/cis-95/pingmon.git
```
```
cd pingmon
```

### 2. ติดตั้ง script ไปที่ /usr/local/bin
```
sudo install -m 755 pingmon.sh /usr/local/bin/pingmon
```

### 3. สร้างโฟลเดอร์ config + log
```
sudo mkdir -p /etc/pingmon /var/log/pingmon
```

### 4. วาง config และ targets (ถ้าไม่มีจะใช้ของ sample)
```
sudo cp config.env /etc/pingmon/config.env
```
```
sudo cp targets.txt /etc/pingmon/targets.txt
```

### 5. ทดสอบ Run
```
pingmon -c /etc/pingmon/config.env
```

### 6. ตั้งค่า Cron/Timer
```
sudo crontab -e
```
ตัวอย่าง cron ทุก 5 นาที:
```
*/5 * * * * /usr/local/bin/pingmon -c /etc/pingmon/config.env >/dev/null 2>&1
```
