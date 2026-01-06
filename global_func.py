from datetime import datetime

from croniter import croniter
from crontab import CronTab

cron = CronTab(user=True)

sekarang = datetime.now()


def get_data():
    data = []
    for job in cron:
        jadwal = str(job.slices)
        dipanggil = croniter(jadwal, sekarang)
        data.append({
            "slices": jadwal,
            "command": job.command,
            "comment": job.comment,
            "status": job.is_enabled(),
            "last": dipanggil.get_prev(datetime),
            "next": dipanggil.get_next(datetime),
        })

    data.sort(key=lambda x: (not x['status'], x['next']))
    return data


def translate_slice(slices):
    menit, jam, tanggal, bulan, hari = slices
    print(menit, jam, tanggal, bulan, hari)
