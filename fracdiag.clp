; Memulai program
(defrule start
    =>
    (printout t crlf "Selamat datang di FracDiag!" crlf "Anda dapat melakukan diagnosis awal terhadap gejala yang Anda alami untuk menentukan jenis fraktura yang terjadi pada tulang Anda.")
    (printout t crlf "Yakin ingin melakukan diagnosis? Ya = y ; Tidak = t" crlf)
    (bind ?ans (read))
    (if(eq ?ans y) then (assert(mulai)))
    (if(eq ?ans t) then (printout t "Program ditutup. Silakan mulai kembali.") crlf)
)

; Memulai diagnosis dengan menanyakan gejala umum pengguna
(defrule isNyeri
    (mulai)
    =>
    (printout t crlf "Apakah terdapat bagian tubuh yang terasa nyeri? Ya = y ; Tidak = t" crlf)
    (bind ?ans (read))
    (if (eq ?ans y) then (assert (nyeri)))
    (if (eq ?ans t) then (assert (tidak_nyeri)))
)

(defrule isPegal
    (nyeri)
    =>
    (printout t crlf "Apakah terdapat bagian tubuh yang pegal saat digerakkan? Ya = y ; Tidak = t" crlf)
    (bind ?ans (read))
    (if (eq ?ans y) then (assert (pegal)))
    (if (eq ?ans t) then (assert (tidak_pegal)))
)

; Terminasi program saat gejala umum tidak terpenuhi 
(defrule safe
    (or (tidak_nyeri) (tidak_pegal))
    =>
    (printout t crlf "Kemungkinan tidak terjadi fraktura pada tubuh Anda. Jaga terus kesehatan tulang!" crlf)
)

; Melanjutkan diagnosis lanjutan apabila gejala umum terpenuhi
(defrule isBerdarah
    (pegal)
    =>
    (printout t crlf "Apakah terdapat bagian tubuh yang berdarah? Ya = y ; Tidak = t" crlf)
    (bind ?ans (read))
    (if (eq ?ans y) then (assert (berdarah)))
    (if (eq ?ans t) then (assert (tidak_berdarah)))
)

(defrule isLuka
    (or (berdarah) (tidak_berdarah))
    =>
    (printout t crlf "Apakah terdapat luka terbuka di bagian tubuh? Ya = y ; Tidak = t" crlf)
    (bind ?ans (read))
    (if (eq ?ans y) then (assert (luka_terbuka)))
    (if (eq ?ans t) then (assert (luka_tertutup)))
)

(defrule isTulangTembus
    (or (luka_terbuka) (luka_tertutup))
    =>
    (printout t crlf "Ada tulang yang menembus dan keluar melukai kulit tubuh? Ya = y ; Tidak = t" crlf)
    (bind ?ans (read))
    (if (eq ?ans y) then (assert (tulang_tembus)))
    (if (eq ?ans t) then (assert (tulang_tidak_tembus)))
)

(defrule isRontgen
    (or (tulang_tembus) (tulang_tidak_tembus))
    =>
    (printout t crlf "Apakah sudah melakukan rontgen? Sudah = y ; Belum = t" crlf)
    (bind ?ans (read))
    (if (eq ?ans y) then (assert (rontgen)))
    (if (eq ?ans t) then (assert (not_rontgen)))
)

(defrule isPatahParsialTotal
    (rontgen)
    =>
    (printout t crlf "Bagaimana hasil rontgen yang didapatkan? (1/2)" crlf "1. Tulang bergeser dan ujung patahan tulang tidak sejajar" crlf "2. Tulang tidak bergeser dan berada pada posisi sejajar" crlf)
    (bind ?ans (read))
    (if (= ?ans 1) then (assert (displaced_fracture)))
    (if (= ?ans 2) then (assert (nondisplaced_fracture)))
)

; Menentukan jenis fraktura berdasarkan diagnosis yang telah dilakukan dari data pengguna
(defrule isFrakturaTerbuka
    (and (nyeri) (pegal) (berdarah) (luka_terbuka) (tulang_tembus))
    =>
    (printout t crlf "Anda kemungkinan mengalami patah tulang terbuka (fraktur terbuka)." crlf "Fraktur terbuka adalah kondisi saat patah tulang disertai luka pada kulit dan sekitar lokasi patah tulang." crlf)
)

(defrule isFrakturaTertutup
    (and (nyeri) (pegal) (tidak_berdarah) (luka_tertutup) (tulang_tidak_tembus))
    =>
    (printout t crlf "Anda kemungkinan mengalami patah tulang tertutup (fraktur tertutup)." crlf "Fraktur tertutup adalah kondisi saat patah tulang tidak disertai luka pada kulit dan sekitar lokasi patah tulang." crlf)
)

(defrule isFrakturaTotal
    (and (nyeri) (pegal) (rontgen) (displaced_fracture))
    =>
    (printout t crlf "Anda kemungkinan mengalami patah tulang displaced (displaced fracture)." crlf "Displaced fracture adalah tipe fraktur yang terjadi ketika tulang yang patah bergeser dan ujung-ujung patahan tulang tersebut menjadi tidak sejajar." crlf)
)

(defrule isFrakturaParsial
    (and (nyeri) (pegal) (rontgen) (nondisplaced_fracture))
    =>
    (printout t crlf "Anda kemungkinan mengalami patah tulang nondisplaced (nondisplaced fracture)." crlf "Nondisplaced fracture adalah tipe fraktur yang terjadi ketika tulang yang patah tidak bergeser dan ujung-ujung patahan tulang tersebut tetap sejajar." crlf)
)

; Handling exception tertentu saat menjalankan diagnosis
(defrule undef
    (or (and (nyeri) (pegal) (berdarah) (luka_tertutup) (tulang_tembus))
        (and (nyeri) (pegal) (berdarah) (luka_tertutup) (tulang_tidak_tembus))
        (and (nyeri) (pegal) (tidak_berdarah) (luka_terbuka) (tulang_tembus))
        (and (nyeri) (pegal) (tidak_berdarah) (luka_terbuka) (tulang_tidak_tembus))
    )
    =>
    (printout t crlf "Terdapat kesalahan saat proses diagnosis. Silakan ulangi diagnosis." crlf)
)