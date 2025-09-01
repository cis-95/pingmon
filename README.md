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

### 4. วาง config และ targets
```
sudo cp config.env /etc/pingmon/config.env
```
```
sudo cp targets.txt /etc/pingmon/targets.txt
```

### 5. แก้ไขไฟล์ config.env และ target.txt
```
sudo vi /etc/pingmon/config.env
```
```
sudo vi /etc/pingmon/targets.txt
```

### 6. ทดสอบ Run
```
pingmon -c /etc/pingmon/config.env
```

### 7. ตั้งค่า Cron/Timer
```
sudo crontab -e
```
ตัวอย่าง cron ทุก 5 นาที:
```
*/5 * * * * /usr/local/bin/pingmon -c /etc/pingmon/config.env >/dev/null 2>&1
```
---

## 📂 โครงสร้าง Log
/var/log/pingmon/
├─ 10.10.1.10/
│   └─ 2025-09-01.log
├─ 10.10.1.11/
│   └─ 2025-09-01.log
└─ 10.10.2.20/
└─ 2025-09-01.log

---

## 📊 ตัวอย่างการตรวจสอบ Log

ดึงบรรทัดล่าสุด 5 บรรทัด ของ IP `10.10.1.10`:

```bash
tail -n 5 /var/log/pingmon/10.10.1.10/$(date +%F).log
```
ตัวอย่างผลลัพธ์:
```
2025-09-01T13:37:00+07:00,up,0,0.72,0
2025-09-01T13:42:00+07:00,down,100,,1
2025-09-01T13:47:00+07:00,up,0,0.65,0
2025-09-01T13:52:00+07:00,up,0,0.69,0
2025-09-01T13:57:00+07:00,up,0,0.71,0
```
ฟิลด์แต่ละคอลัมน์
```
timestamp,status,loss_percent,avg_rtt_ms,exit_code
```

•	status = up / down

•	loss_percent = % packet loss

•	avg_rtt_ms = ค่าเฉลี่ยเวลา ping (ms)

•	exit_code = ค่าที่ ping คืนกลับ (0 = สำเร็จ, อื่น ๆ = ล้มเหลว)