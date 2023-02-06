BEGIN {
    PdfLeft  = ARGV[1]
    PdfRight = ARGV[2]
    print "Will join '" PdfLeft "' and '" PdfRight "'..."
    "pdftk " PdfLeft " dumpdata | grep NumberOfPages" | getline
    NumberOfPages = $2
    print "Number of pages: " NumberOfPages
    explodeToPages(PdfLeft)
    explodeToPages(PdfRight)
}

function explodeToPages(file,   fileNoExt) {
    printf "%s", "Exploding to pages: '" file "'..."
    sub(/\.pdf$/,"",fileNoExt)
    runOrError("pdftk '" file "' burst output '" fileNoExt "-%d.pdf'")
    print " done."
}

function runOrError(cmd) {
    if (system(cmd) == 0) { close(cmd); return }
    print "error running: " cmd >> "/dev/stderr"
    exit 1
}
