# PeduliBeacon

## Setup HM 10 Bluetooth Menjadi iBeacon

1. AT -> Melakukan pengecekan bluetooth
2. AT+MARJ0x1000 -> Mengubah Major data menjadi 0X1000 
3. AT+MINO0x0007 -> Megubah Minor data menjadi 0x0007
4. AT+ADVI5 -> Mengubah advertising interval menjadi mode 5: 546.25 ms (untuk lebih lengkapnya bisa lihat doc. AT-Command)
5. AT+NAMEiBeacon -> Mengubah nama bluetooth HM10 menjadi iBeacon
6. AT+ADTY3 -> Mengubah bluetooth HM 10 menjadi mode 3: Non connectable (only allow advertising), save power
7. AT+IBEA1 -> Aktivasi iBeacon mode pada HM10
8. AT+DELO2 -> Mengubah iBeacon HM10 mode hanya melakukan broadcast, save power
9. AT+PWRM0 -> Mengaktifkan mode autosleep untuk menurunkan power (iBeacon akan tetap melakukan transmisi advertisement)
10. AT+RESET

Untuk Mengubah UUID dari iBeacon

1. AT
2. AT+IBEA? -> Mengembalikan UUID Beacon: defaultnya "74278BDA-B644-4520-8F0C-720EAF059935"
3. AT+IBEXYYYYYYYY -> Untuk mengebuah UUID Beacon. X=urutan per 4 byte, Y data yang ingin diganti.
Contoh: jika kita ingin mengganti 4 byte terakhir default UUID "AF059935" maka kita mengirimkan
AT+IBE312345678
4. AT+RESET

Untuk lebih lengkapnya bisa langsung mengakses AT Command set dari HM10: https://people.ece.cornell.edu/land/courses/ece4760/PIC32/uart/HM10/DSD%20TECH%20HM-10%20datasheet.pdf
