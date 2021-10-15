# Sentimen analisis untuk menentukan kelas very positive, positive, netral, negative, very negative dari sebuah paragraf/teks level dengan metode svm (DAGSVM) dan random forest

## Uraian

## Permasalahan

Pada kebanyakan sistem informasi yang dibuat untuk melalukan evaluasi produk, seperti software, toko online dan lainnya, kebanyakan pihak memberikan 2 fitur pada user, komentar dan rating, pada kasusnya user secara heuristik memberikan rating(value) dan komentar yang ingin diberikan. Pada sistem yang tidak memiliki "fitur rating" dan hanya terdapat fitur komentar, maka akan sangat sulit menentukan "pendapat publik" dari keseluruhan sentimen yang ada terhadap suatu aspek atau produk.

## Tujuan

Membangun sebuah sistem yang dapat mengklasifikasi bagian very positive, positive, netral, negative, very negative dari sebuah teks.

## Alur Pengerjaan Projek

1.Crawling data teks dan rating yang add pada google play store (karena memiliki komentar yang relatif umum dan relevan) dari berbagai kategori, dimana setiap kategori(ditentukan game dan sosial media) didapat list aplikasi, dari setiap aplikasi didapat data komentar yang dibutuhkan.

2.Cleaning, data yang diterima sebelumnya dalam bentuk json,diambil hanya nama aplikasi/produk(sebagai attribut kunci), rating keseluruhan, komentar dan rating yang diberikan dari setiap user.

3.Normalization, untuk setiap kata dari komentar yang tidak ada pada kata dasar(misal singkatan) maka di-lookup untuk setiap kata dasar dengan mengabaikan huruf konsonan dari kata, karena besarnya biaya untuk setiap kombinasi huruf yang terbentuk, - yang : yg ,y yag, maka dibuat kamus singkatan dari data yang telah dicrawling kamus yang terbentuk nanti digunakan pada tahap ini dengan metode lemmazation. -- Pada project tahap ini belum dikerjakan
> stemming tidak dilakukan karena kamus kata negative dan positive (telah ada) tidak menggunakan kata dasar.

4.Thesaurus, kamus dibangun berdasarkan ke-lima kategori dari data komentar (1,2 dan 3-grams).

5.Features, fitur yang dibangun terdiri dari 24 fitur
    15 awal, (1-grams bintang 1, 2-grams bintang 1 dan 3-grams bintang 1 , hingga bintang 5)
    2 berikutnya, positive dan negative berdasarkan kamus positive negative dari https://github.com/masdevid/ID-OpinionWords


6.Classifications, klasifikasi dilakukan untuk kedua metode dan dibandingkan hasil klasifikasi keduanya.

# referensi

 - https://monkeylearn.com/sentiment-analysis/
 - https://monkeylearn.com/text-classification/
 - https://yudiwbs.wordpress.com/2011/12/26/analisis-twee-analisis-opini-sentimen/
 - https://medium.com/@ageitgey/text-classification-is-your-new-secret-weapon-7ca4fad15788

 - http://www.statmt.org/OSMOSES/FeatureEx.pdf

 crawling : https://play.google.com/store


# pro : 
https://towardsdatascience.com/random-forest-in-python-24d0893d51c0
https://stackabuse.com/random-forest-algorithm-with-python-and-scikit-learn/

https://stackabuse.com/implementing-svm-and-kernel-svm-with-pythons-scikit-learn/