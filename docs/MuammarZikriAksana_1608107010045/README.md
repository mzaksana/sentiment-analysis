# Program Crawling dan Extract Content

> Author: Muammar Zikri Aksana (1608107010045)\
> Date: Jan 2019\
> Department of Informatics\
> College of Science, Syiah Kuala Univ\
> Version : 1.0

## Deskripsi Singkat

Program ini untuk melakukan Crawling dan Extract Content.

Program terdiri dari 4 file utama :

- crawl.pl adalah script untuk melakukan crawling
- extractContent.pl adalah untuk melakukan extract dari file
- util.pl adalah script yang berisikan fungsi-fungsi yang diperlukan untuk crawl dan extract
- generateUrl.pl script untuk melakukan proses transformasi url untuk dicrawling

Untuk melakukan crawling dibutuhkan url yang memiliki pola dinamis , seperti index berita yang memiliki pola untuk setiap index harinya.\
Untuk menjalankan extractcontent hanya dibutuhkan file sumber yang ingin diextract

## Run Program

Script yang dapat dijalankan pada program ini adalah crawl.pl dan extractcontent.pl

### Crawling

ex : url for crawling , http://www.news.com/blabla/news-sport/day=01-mm=03#year=2019

```bash
    perl crawl.pl nama-statis-file "url" day folder url-filter
    perl crawl.pl news-sport "http://www.news.com/blabla/news-sport/{date:tanggal=day=%d-mm=%m#year=%Y}" 10 /home/mza/doc '/read/'
```

dari perintah pada baris kedua artinya :

- news-sport adalah prefix dari hasil crawling, pada program versi 1.0 ini format extensi hasil ditentukan dalam hard code :
  - news-sport-1.html
  - news-sport-2.html
  - etc
- "url" adalah url dari web yang akan dicrawling, url tersebut harus memiliki pola , seperti tanggal. Pada program versi 1.0 ini program crawling telah support 2 metode yaitu date dan inc:

  - date:tanggal=format
  - inc:tanggalAja=format

    pada date artinya transformasi url akan menggunakan format date\
    pada inc transformasi url dalam bentuk counter 1,2,3 .. n.\
    bagian dinamis/yang akan selalu diubah diapit oleh {_trasnform_}.

- 10 adalah jumlah hari/counter untuk perbuhan url dari "url" yang telah diberikan sebelumnya
- /home/mza/ adalah folder dimana hasil crawling disimpan
- '/read/' adalah filter index yang ingin dicrawling, misalkan situs berita memiliki bagian khusus pada url yang menyatakan artikel misal .../news/read/art--.... , filter ditentukan secara heuristik.
  - (.\*) : untuk mengambil semua yang didapat tanpa filter

### Extract Content

```bash
    perl extractcontent.pl source destination
```

Pada contoh diatas ;

- source : adalah folder dimana sumber dari yang ingin di extract berada
- destination : adalah folder dimana hasil extract disimpan

Program ini akan mempertahankan struktur folder dengan 2 kedalaman dari source
ex source :

    - data/crawl/bola
    - data/crawl/
    - data/crawl/news/bola
    - data/crawl/news/sport/

maka folder yang akan terbentuk pada destination
ex dst : data/clean, maka:

    - data/crawl/bola --apapun pada source
    - data/crawl/ --apapun pada source
    - data/crawl/news/bola --apapun pada source
    - data/crawl/news/sport/ --apapun pada source

Permasalahan struktur folder untuk v 1.0 ini harus diubah langsung dalam code.
