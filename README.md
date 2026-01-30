cat << 'EOF' > README.md
# [Persian](#نصب-یک-دستوری-ایستگاه-سایفون-conduit) | [English](#psiphon-conduit-one-command-installer)

---

# نصب یک دستوری ایستگاه سایفون (Conduit)

نصب آسان پل سایفون با داکر برای کمک به آزادی اینترنت در ایران

یادبودی برای خون های پاک:
این پروژه تقدیم می شود به شهدای هجده و نوزده دی ماه؛ روزهایی که در تاریکی مطلق قطع اینترنت، صدای حق خواهی مردم با گلوله پاسخ داده شد.

"اگه چراغ رو خاموش می کنی و پرده ها رو می کشی، خودت می دونی کاری که می کنی درست نیست. کسی که کارش درسته، از تاریکی نمی ترسه."

این ابزار سهم کوچکی برای شکستن آن تاریکی است.

رامتین رحمانی نژاد - نت ادمین پلاس
YouTube: @netadminplus | Website: netadminplus.com

---

### امکانات
- نصب خودکار داکر و اجرای ایستگاه با یک دستور
- فرمان اختصاصی conduit برای مدیریت راحت از هر جای سیستم
- محدودیت رم برای حفظ پایداری سرور
- گزارش لحظه ای کاربران و ترافیک
- شروع به کار خودکار بعد از ریبوت سرور

---

### پیش نیازها
- سرور لینوکس خارج از ایران (Ubuntu/Debian)
- حداقل 512 مگابایت رم

---

### نصب و راه اندازی
دستور زیر را در ترمینال اجرا کنید:

```bash
curl -fsSL [https://raw.githubusercontent.com/netadminplus/conduit-docker/main/install.sh](https://raw.githubusercontent.com/netadminplus/conduit-docker/main/install.sh) | bash

### مدیریت ایستگاه (Conduit Commands)
بعد از نصب، از این دستورات استفاده کنید:

- **conduit report** : مشاهده آمار کاربران و ترافیک
- **conduit logs** : مشاهده لاگ های سیستم
- **conduit down** : متوقف کردن ایستگاه
- **conduit up** : شروع به کار ایستگاه
- **conduit restart** : ریستارت سرویس

---

### ساختار فایل ها
- مسیر پروژه: ~/conduit-docker
- فایل تنظیمات: docker-compose.yaml
- پوشه دیتا: conduit-data

---

### حمایت
1. ستاره (Star) دادن به این پروژه در گیت هاب
2. سابسکرایب کانال یوتیوب نت ادمین پلاس
3. اشتراک گذاری لینک با ایرانیان خارج از کشور

---

# Psiphon Conduit One-Command Installer
Deploy a Psiphon Bridge (Conduit) station easily with Docker.

### Quick Start
Run this on your Linux server:
`curl -fsSL https://raw.githubusercontent.com/netadminplus/conduit-docker/main/install.sh | bash`

### Management Commands
- **conduit report** : View live stats
- **conduit logs** : Check logs
- **conduit up** : Start station
- **conduit down** : Stop station
- **conduit restart** : Restart service

### License
MIT License - Free to use and share.


